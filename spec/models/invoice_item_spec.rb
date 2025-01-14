require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end
  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
  end

  describe "instance methods" do
    describe "discounted price" do
      it 'returns the price of an invoice item after applying the best possible discount' do
        m1 = Merchant.create!(name: 'Merchant 1')
        c1 = Customer.create!(first_name: 'Bilbo', last_name: 'Baggins')
        item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10, merchant_id: m1.id)
        i1 = Invoice.create!(customer_id: c1.id, status: 2)
        ii_1 = InvoiceItem.create!(invoice_id: i1.id, item_id: item_1.id, quantity: 25, unit_price: 10, status: 0)
        ii_2 = InvoiceItem.create!(invoice_id: i1.id, item_id: item_1.id, quantity: 10, unit_price: 10, status: 0)
        bd1 = m1.bulk_discounts.create!(percentage_discount: 15, quantity_threshold: 20)
        bd2 = m1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 25)

        expect(ii_1.discounted_revenue(m1)).to eq(200)
        expect(ii_2.discounted_revenue(m1)).to eq(100)
      end
    end

    describe "applied_discount" do
      it 'returns the bulk_discount object applied to an invoice item, if any' do
        m1 = Merchant.create!(name: 'Merchant 1')
        c1 = Customer.create!(first_name: 'Bilbo', last_name: 'Baggins')
        item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10, merchant_id: m1.id)
        i1 = Invoice.create!(customer_id: c1.id, status: 2)
        ii_1 = InvoiceItem.create!(invoice_id: i1.id, item_id: item_1.id, quantity: 25, unit_price: 10, status: 0)
        ii_2 = InvoiceItem.create!(invoice_id: i1.id, item_id: item_1.id, quantity: 21, unit_price: 10, status: 0)
        bd1 = m1.bulk_discounts.create!(percentage_discount: 15, quantity_threshold: 20)
        bd2 = m1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 25)

        expect(ii_1.applied_discount(m1)).to eq(bd2)
        expect(ii_2.applied_discount(m1)).to eq(bd1)
      end
    end

    describe "applicable_discount?" do
      it 'returns true if a discount can be applied, false otherwise' do
        m1 = Merchant.create!(name: 'Merchant 1')
        c1 = Customer.create!(first_name: 'Bilbo', last_name: 'Baggins')
        item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10, merchant_id: m1.id)
        i1 = Invoice.create!(customer_id: c1.id, status: 2)
        ii_1 = InvoiceItem.create!(invoice_id: i1.id, item_id: item_1.id, quantity: 25, unit_price: 10, status: 0)
        ii_2 = InvoiceItem.create!(invoice_id: i1.id, item_id: item_1.id, quantity: 10, unit_price: 10, status: 0)
        bd1 = m1.bulk_discounts.create!(percentage_discount: 15, quantity_threshold: 20)
        bd2 = m1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 25)

        expect(ii_1.applicable_discount?(m1)).to eq(true)
        expect(ii_2.applicable_discount?(m1)).to eq(false)
      end
    end

    describe "revenue" do
      it 'returns the revenue before a discount is applied' do
        m1 = Merchant.create!(name: 'Merchant 1')
        c1 = Customer.create!(first_name: 'Bilbo', last_name: 'Baggins')
        item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10, merchant_id: m1.id)
        i1 = Invoice.create!(customer_id: c1.id, status: 2)
        ii_1 = InvoiceItem.create!(invoice_id: i1.id, item_id: item_1.id, quantity: 25, unit_price: 10, status: 0)
        ii_2 = InvoiceItem.create!(invoice_id: i1.id, item_id: item_1.id, quantity: 10, unit_price: 10, status: 0)

        expect(ii_1.revenue).to eq(250)
        expect(ii_2.revenue).to eq(100)
      end
    end

  end
  describe "class methods" do
    before(:each) do
      @m1 = Merchant.create!(name: 'Merchant 1')
      @c1 = Customer.create!(first_name: 'Bilbo', last_name: 'Baggins')
      @c2 = Customer.create!(first_name: 'Frodo', last_name: 'Baggins')
      @c3 = Customer.create!(first_name: 'Samwise', last_name: 'Gamgee')
      @c4 = Customer.create!(first_name: 'Aragorn', last_name: 'Elessar')
      @c5 = Customer.create!(first_name: 'Arwen', last_name: 'Undomiel')
      @c6 = Customer.create!(first_name: 'Legolas', last_name: 'Greenleaf')
      @item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10, merchant_id: @m1.id)
      @item_2 = Item.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8, merchant_id: @m1.id)
      @item_3 = Item.create!(name: 'Brush', description: 'This takes out tangles', unit_price: 5, merchant_id: @m1.id)
      @i1 = Invoice.create!(customer_id: @c1.id, status: 2)
      @i2 = Invoice.create!(customer_id: @c1.id, status: 2)
      @i3 = Invoice.create!(customer_id: @c2.id, status: 2)
      @i4 = Invoice.create!(customer_id: @c3.id, status: 2)
      @i5 = Invoice.create!(customer_id: @c4.id, status: 2)
      @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
      @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
      @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
      @ii_4 = InvoiceItem.create!(invoice_id: @i3.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 1)
    end
    it 'incomplete_invoices' do
      expect(InvoiceItem.incomplete_invoices).to eq([@i1, @i3])
    end
  end
end

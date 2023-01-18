require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "validations" do
    it { should validate_presence_of :status }
    it { should validate_presence_of :customer_id }
  end
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many :transactions}
  end
  describe "instance methods" do
    describe "total_revenue" do
      it "returns the full revenue of the invoice" do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @merchant2 = Merchant.create!(name: 'Dude')
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 10, merchant_id: @merchant1.id)
        @item_2 = Item.create!(name: "Butterfly Knife", description: "Look cool while dicing carrots", unit_price: 10, merchant_id: @merchant2.id)
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 12, unit_price: 10, status: 1)

        expect(@invoice_1.total_revenue).to eq(220)
      end
    end

    describe "total_discounted_revenue" do
      it "returns the discounted revenue of the invoice with disocunts applied from any merchant(if applicable)" do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @merchant2 = Merchant.create!(name: 'Dude')
        @merchant1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 5)
        @merchant2.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 5)
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 10, merchant_id: @merchant1.id)
        @item_2 = Item.create!(name: "Butterfly Knife", description: "Look cool while dicing carrots", unit_price: 10, merchant_id: @merchant2.id)
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 12, unit_price: 10, status: 1)

        expect(@invoice_1.total_discounted_revenue).to eq(178)
      end
    end

    describe "merchant_total_revenue" do
      it "returns the revenue for a specififc merchant before applying discounts" do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @merchant2 = Merchant.create!(name: 'Dude')
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 10, merchant_id: @merchant1.id)
        @item_2 = Item.create!(name: "Butterfly Knife", description: "Look cool while dicing carrots", unit_price: 10, merchant_id: @merchant2.id)
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 12, unit_price: 10, status: 1)

        expect(@invoice_1.merchant_total_revenue(@merchant1)).to eq(100)
      end
    end

    describe "merchant_total_discounted_revenue" do
      it "returns the revenue for a specififc merchant after applying discounts" do
        @merchant1 = Merchant.create!(name: 'Hair Care')
        @merchant2 = Merchant.create!(name: 'Dude')
        @merchant1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 5)
        @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
        @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 10, merchant_id: @merchant1.id)
        @item_2 = Item.create!(name: "Butterfly Knife", description: "Look cool while dicing carrots", unit_price: 10, merchant_id: @merchant2.id)
        @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
        @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
        @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 2)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 10, status: 1)
        @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 12, unit_price: 10, status: 1)

        expect(@invoice_1.merchant_total_discounted_revenue(@merchant1)).to eq(82)
      end
    end
  end
end

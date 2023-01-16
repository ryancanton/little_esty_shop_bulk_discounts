require 'rails_helper'

RSpec.describe 'A Bulk Discount Show Page' do
  it 'contains the percentage and quantity threshold of the discount' do
    merchant1 = Merchant.create!(name: 'Hair Care')
    bulk_discount_1 = merchant1.bulk_discounts.create!(percentage_discount: 25, quantity_threshold: 30)

    visit merchant_bulk_discount_path(merchant1.id, bulk_discount_1.id)

    expect(page).to have_content(bulk_discount_1.percentage_discount)
    expect(page).to have_content(bulk_discount_1.quantity_threshold)
  end
end
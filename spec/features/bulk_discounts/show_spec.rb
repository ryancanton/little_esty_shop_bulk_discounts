require 'rails_helper'

RSpec.describe 'A Bulk Discount Show Page' do
  it 'contains the percentage and quantity threshold of the discount' do
    merchant1 = Merchant.create!(name: 'Hair Care')
    bulk_discount_1 = merchant1.bulk_discounts.create!(percentage_discount: 25, quantity_threshold: 30)

    visit merchant_bulk_discount_path(merchant1.id, bulk_discount_1.id)

    expect(page).to have_content(bulk_discount_1.percentage_discount)
    expect(page).to have_content(bulk_discount_1.quantity_threshold)
  end

  it 'contains a link that allows you to edit the discount' do
    merchant1 = Merchant.create!(name: 'Hair Care')
    bulk_discount_1 = merchant1.bulk_discounts.create!(percentage_discount: 25, quantity_threshold: 30)

    visit merchant_bulk_discount_path(merchant1.id, bulk_discount_1.id)

    expect(page).to have_link("Edit Bulk Discount")
    click_link("Edit Bulk Discount")
    expect(current_path).to eq(edit_merchant_bulk_discount_path(merchant1.id, bulk_discount_1.id))
    expect(page).to have_field(:percentage_discount, with: bulk_discount_1.percentage_discount)
    expect(page).to have_field(:quantity_threshold, with: bulk_discount_1.quantity_threshold)

    fill_in :percentage_discount, with: '35'
    click_button 'Save'

    expect(current_path).to eq(merchant_bulk_discount_path(merchant1.id, bulk_discount_1.id))
    expect(page).to have_content("Percentage Discount: 35")
  end
end
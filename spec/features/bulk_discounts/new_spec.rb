require 'rails_helper'

RSpec.describe 'The Bulk Discount New Page' do
  it 'contains a form to create a new bulk discount and redirect to the bulk discount index page' do
    merchant = Merchant.create!(name: "Apple")

    visit new_merchant_bulk_discount_path(merchant.id)

    fill_in :percentage_discount, with: '20'
    fill_in :quantity_threshold, with: '15'
    click_button 'Save'

    expect(current_path).to eq(merchant_bulk_discounts_path(merchant.id))
    expect(page).to have_content('20')
    expect(page).to have_content('15')
  end
end


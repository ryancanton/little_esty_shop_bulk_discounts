require 'rails_helper'

RSpec.describe 'A Merchants Bulk Discounts Index Page' do
  it 'contains each of a merchants bulk discounts including threshold and percent' do
    merchant1 = Merchant.create!(name: 'Hair Care')
    merchant2 = Merchant.create!(name: 'Gummy Yummies')
    bulk_discount_1 = merchant1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 15)
    bulk_discount_2 = merchant1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 15)
    bulk_discount_3 = merchant1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 15)
    bulk_discount_4 = merchant1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 15)
    bulk_discount_5 = merchant1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 15)
    bulk_discount_98 = merchant2.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 15)

    visit merchant_bulk_discounts_path(merchant1)
    within "div#bulk_discount#{bulk_discount_1.id}" do
      expect(page).to have_content(bulk_discount_1.percentage_discount)
      expect(page).to have_content(bulk_discount_1.quantity_threshold)
    end
    within "div#bulk_discount#{bulk_discount_2.id}" do
      expect(page).to have_content(bulk_discount_2.percentage_discount)
      expect(page).to have_content(bulk_discount_2.quantity_threshold)
    end
    within "div#bulk_discount#{bulk_discount_3.id}" do
      expect(page).to have_content(bulk_discount_3.percentage_discount)
      expect(page).to have_content(bulk_discount_3.quantity_threshold)
    end
    within "div#bulk_discount#{bulk_discount_4.id}" do
      expect(page).to have_content(bulk_discount_4.percentage_discount)
      expect(page).to have_content(bulk_discount_4.quantity_threshold)
    end
    within "div#bulk_discount#{bulk_discount_5.id}" do
      expect(page).to have_content(bulk_discount_5.percentage_discount)
      expect(page).to have_content(bulk_discount_5.quantity_threshold)
    end
  end

  it 'each bulk discount has a link to its show page' do
    merchant1 = Merchant.create!(name: 'Hair Care')
    bulk_discount_1 = merchant1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 15)
    bulk_discount_2 = merchant1.bulk_discounts.create!(percentage_discount: 20, quantity_threshold: 15)

    visit merchant_bulk_discounts_path(merchant1)

    within "div#bulk_discount#{bulk_discount_1.id}" do
      expect(page).to have_link('Discount Show Page', href: merchant_bulk_discount_path(merchant1.id, bulk_discount_1.id))
    end
    within "div#bulk_discount#{bulk_discount_2.id}" do
      expect(page).to have_link('Discount Show Page', href: merchant_bulk_discount_path(merchant1.id, bulk_discount_2.id))
    end
  end
end
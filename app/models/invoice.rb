class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, 'in progress', :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_discounted_revenue
    invoice_items.sum do |invoice_item|
      invoice_item.discounted_revenue
    end
  end

  def applied_discounts
    discounts = invoice_items.map do |ii|
      ii.item.merchant.bulk_discounts.where('quantity_threshold <= ?', ii.quantity).order(percentage_discount: :desc).limit(1)
    end.flatten
  end
end

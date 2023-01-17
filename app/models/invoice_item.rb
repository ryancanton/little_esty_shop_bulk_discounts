class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def discounted_revenue
    merchant = self.item.merchant
    best_discount = merchant.bulk_discounts.where('quantity_threshold <= ?', self.quantity).order(percentage_discount: :desc).limit(1)
    if (best_discount.length > 0)
      discounted_revenue = (self.quantity * self.unit_price) - (self.quantity * self.unit_price) * (best_discount[0].percentage_discount / 100.0)
    else 
      discounted_revenue = (self.quantity * self.unit_price)
    end
  end
end
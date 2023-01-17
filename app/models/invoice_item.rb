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

  def revenue
    InvoiceItem.where(id: self.id).sum("unit_price * quantity")
  end

  def applied_discount
    self.item.merchant.bulk_discounts.where('quantity_threshold <= ?', self.quantity).order(percentage_discount: :desc).limit(1)[0]
  end

  def applicable_discount?
    self.item.merchant.bulk_discounts.where('quantity_threshold <= ?', self.quantity).order(percentage_discount: :desc).limit(1).length > 0
  end

  def discounted_revenue
    if (applicable_discount?)
      discounted_revenue = revenue * ((100 - applied_discount.percentage_discount) / 100.0)
    else 
      discounted_revenue = revenue
    end
  end
end
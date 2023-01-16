class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show

  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    BulkDiscount.create!(bulk_discount_params)
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  private
  def bulk_discount_params
    params.permit(:id, :percentage_discount, :quantity_threshold, :merchant_id)
  end
end
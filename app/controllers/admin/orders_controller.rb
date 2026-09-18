class Admin::OrdersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :redirect_order_not_found

  def index
    # 注文を作成日時の降順で取得
    @orders = Order.includes(order_items: { sku: :product}).order(created_at: :desc)
  end

  def show
    @order = Order.includes(order_items: { sku: :product}).find(params[:id])
  end

  private

  def redirect_order_not_found
    redirect_to admin_orders_path, alert: t('flash.admin.orders.not_found')
  end
end

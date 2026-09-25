class Admin::Orders::CompletionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :redirect_order_not_found

  before_action :set_order
  before_action :reject_if_completed

  # POST /admin/orders/:order_id/completion
  # 管理者が注文を完了状態にする。
  def create
    @order.status_complete!
    redirect_to admin_order_path(@order), notice: t('flash.admin.orders.complete.notice')
  end

  private

  def set_order
    @order = Order.includes(order_items: { sku: :product }).find(params[:order_id])
  end

  def reject_if_completed
    return unless @order.status_complete?

    redirect_to admin_order_path(@order), alert: t('flash.admin.orders.complete.alert')
  end

  def redirect_order_not_found
    redirect_to admin_orders_path, alert: t('flash.admin.orders.not_found')
  end
end

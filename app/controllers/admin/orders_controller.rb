class Admin::OrdersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :redirect_order_not_found

  before_action :set_order, only: [:show, :complete]
  before_action :reject_if_completed, only: [:complete]

  def index
    @q = Order.ransack(search_params)
    @orders = @q.result(distinct: true)
              .includes(order_items: { sku: :product})
              .order(created_at: :desc)
  end

  def show
  end

  def complete
    @order.status_complete!
    redirect_to admin_order_path(@order), notice: t('flash.admin.orders.complete.notice')
  end

  private

  def redirect_order_not_found
    redirect_to admin_orders_path, alert: t('flash.admin.orders.not_found')
  end

  def search_params
    params.fetch(:q, {}).permit(:id_eq, :customer_name_cont, :customer_email_cont, :status_eq)
  end

  def set_order
    @order = Order.includes(order_items: { sku: :product}).find(params[:id])
  end

  def reject_if_completed
    return unless @order.status_complete?

    redirect_to admin_order_path(@order), alert: t('flash.admin.orders.complete.alert')
  end
end

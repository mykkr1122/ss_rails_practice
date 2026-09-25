class Admin::OrdersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :redirect_order_not_found

  before_action :set_order, only: [:show]

  # GET /admin/orders
  # 受注一覧を表示する。ransackによる検索に対応。
  def index
    @q = Order.ransack(search_params)
    @orders = @q.result(distinct: true)
              .includes(order_items: { sku: :product})
              .order(created_at: :desc)
  end

  # GET /admin/orders/:id
  # 受注詳細を表示する。
  def show
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
end

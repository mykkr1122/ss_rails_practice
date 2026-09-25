class Api::V1::Admin::OrdersController < Api::V1::BaseController
  # GET /api/v1/admin/orders
  # 受注一覧を返す。ransackによる検索に対応。
  def index
    q = Order.ransack(search_params)
    orders = q.result(distinct: true).includes(order_items: { sku: :product }).order(created_at: :desc)
    render json: orders
  end

  # GET /api/v1/admin/orders/:id
  # 受注詳細を返す。
  def show
    order = Order.includes(order_items: { sku: :product }).find(params[:id])
    render json: order
  end

  private

  def search_params
    params.fetch(:q, {}).permit(:id_eq, :customer_name_cont, :customer_email_cont, :status_eq)
  end
end

class Api::V1::OrdersController < Api::V1::BaseController
  # GET /api/v1/orders
  # ログインユーザー自身の注文一覧を返す。
  def index
    orders = current_user.orders.includes(order_items: { sku: :product }).order(created_at: :desc)
    render json: orders, methods: [:subtotal, :tax, :total_price]
  end

  # GET /api/v1/orders/:id
  # 自分の注文詳細を返す。他人の注文はRecordNotFoundで404になる。
  def show
    order = current_user.orders.find(params[:id])
    render json: order, methods: [:subtotal, :tax, :total_price]
  end

  # POST /api/v1/orders
  # カートから注文を作成する。
  def create
    order = Order.create_from_cart(
      current_cart_for_api, order_params[:customer_name], order_params[:customer_email],
      user: current_user, address_attributes: order_params.slice(:shipping_address_attributes, :billing_address_attributes)
    )
    if order.errors.empty?
      render json: order, methods: [:subtotal, :tax, :total_price], status: :created
    else
      render json: { error: { messages: order.errors.full_messages } }, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.require(:order).permit(
      :customer_name, :customer_email,
      shipping_address_attributes: [:postal_code, :prefecture, :city, :address_line],
      billing_address_attributes: [:postal_code, :prefecture, :city, :address_line]
    )
  end
end

class OrdersController < ApplicationController
  include OrderOwnership

  before_action :authenticate_user!, only: [:index]
  before_action :require_own_order, only: [:show]
  before_action :redirect_if_unpaid_order, only: [:new, :create]

  # GET /orders
  # ログインユーザー自身の注文一覧を表示する。
  def index
    @orders = current_user.orders
                          .includes(order_items: { sku: :product })
                          .order(created_at: :desc)
  end

  # GET /orders/new
  # カートの中身をもとに注文確認画面を表示する。
  def new
    if current_cart.blank? || current_cart.cart_items.empty?
      redirect_to cart_path, alert: t("flash.orders.empty_cart")
      return
    end

    @order = Order.new
    if user_signed_in?
      @order.customer_name = current_user.name
      @order.customer_email = current_user.email
    end
    @cart_items = current_cart.cart_items.includes(sku: :product)
  end

  # POST /orders
  # カートから注文を作成し、支払い画面へ遷移する。
  def create
    name, email, user = checkout_customer
    @order = Order.create_from_cart(current_cart, name, email, user: user)

    if @order.errors.empty?
      session[:order_id] = @order.id
      redirect_to order_payment_path(@order),
                  notice: t("flash.orders.create.notice")
    elsif current_cart.blank? || current_cart.cart_items.empty?
      redirect_to cart_path, alert: @order.errors.full_messages.to_sentence.presence || t("flash.orders.empty_cart")
    else
      @cart_items = current_cart.cart_items.includes(sku: :product)
      flash.now[:alert] = t("flash.orders.create.alert")
      render :new
    end
  end

  # GET /orders/:id
  # 注文詳細を表示する。未決済の場合は支払い画面へリダイレクトする。
  def show
    redirect_to order_payment_path(@order) if @order.status_new?
  end

  private

  def order_params
    params.require(:order).permit(:customer_name, :customer_email)
  end

  def checkout_customer
    if user_signed_in?
      [current_user.name, current_user.email, current_user]
    else
      [order_params[:customer_name], order_params[:customer_email], nil]
    end
  end

  def redirect_if_unpaid_order
    return if unpaid_order.blank?

    redirect_to order_payment_path(unpaid_order), alert: t('flash.orders.unpaid_exists')
  end

  def require_own_order
    @order = Order.includes(order_items: { sku: :product }).find(params[:id])
    raise ActiveRecord::RecordNotFound unless own_order?(@order)
  end
end

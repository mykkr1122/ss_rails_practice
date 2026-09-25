class OrdersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :redirect_order_not_found

  before_action :authenticate_user!, only: [:index]
  before_action :require_own_order, only: [:show, :payment, :pay]
  before_action :redirect_if_unpaid_order, only: [:new, :create]

  def index
    @orders = current_user.orders
                          .includes(order_items: { sku: :product })
                          .order(created_at: :desc)
  end

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

  def create
    name, email, user = checkout_customer
    @order = Order.create_from_cart(current_cart, name, email, user: user)

    if @order.errors.empty?
      session[:order_id] = @order.id
      redirect_to payment_order_path(@order),
                  notice: t("flash.orders.create.notice")
    elsif current_cart.blank? || current_cart.cart_items.empty?
      redirect_to cart_path, alert: @order.errors.full_messages.to_sentence.presence || t("flash.orders.empty_cart")
    else
      @cart_items = current_cart.cart_items.includes(sku: :product)
      flash.now[:alert] = t("flash.orders.create.alert")
      render :new
    end
  end

  def show
    redirect_to payment_order_path(@order) if @order.status_new?
  end

  def payment
    redirect_to order_path(@order) if @order.status_complete?
  end

  def pay
    if @order.status_complete?
      redirect_to order_path(@order), notice: t("flash.orders.pay.already")
      return
    end

    @order.status_complete!
    redirect_to order_path(@order), notice: t("flash.orders.pay.notice")
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

    redirect_to payment_order_path(unpaid_order), alert: t('flash.orders.unpaid_exists')
  end

  def require_own_order
    @order = Order.includes(order_items: { sku: :product }).find(params[:id])
    raise ActiveRecord::RecordNotFound unless own_order?(@order)
  end

  def own_order?(order)
    if user_signed_in? && order.user_id == current_user.id
      true
    elsif session[:order_id].to_i == order.id && order.user_id.blank?
      true
    else
      false
    end
  end

  def redirect_order_not_found
    if user_signed_in?
      redirect_to orders_path, alert: t("flash.orders.not_found")
    else
      redirect_to cart_path, alert: t("flash.orders.not_found")
    end
  end
end

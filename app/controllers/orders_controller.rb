class OrdersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :redirect_order_not_found

  before_action :require_own_order, only: [:show, :payment, :pay]
  before_action :redirect_if_unpaid_order, only: [:new, :create]

  def new
    if current_cart.blank? || current_cart.cart_items.empty?
      redirect_to cart_path, alert: t("flash.orders.empty_cart")
      return
    end

    @order = Order.new
    @cart_items = current_cart.cart_items.includes(sku: :product)

  end

  def create
    @order = Order.create_from_cart(
      current_cart,
      order_params[:customer_name],
      order_params[:customer_email]
    )

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

  def redirect_if_unpaid_order
    return if unpaid_order.blank?

    redirect_to payment_order_path(unpaid_order), alert: t('flash.orders.unpaid_exists')
  end

  # 注文者本人かどうかを確認
  def require_own_order
    raise ActiveRecord::RecordNotFound if session[:order_id].blank?
    raise ActiveRecord::RecordNotFound if session[:order_id].to_i != params[:id].to_i

    @order = Order.includes(order_items: { sku: :product }).find(params[:id])
  end

  def redirect_order_not_found
    redirect_to cart_path, alert: t("flash.orders.not_found")
  end
end

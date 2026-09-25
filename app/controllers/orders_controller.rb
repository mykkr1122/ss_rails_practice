class OrdersController < ApplicationController
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
      redirect_to order_path(@order),
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
    raise ActiveRecord::RecordNotFound if session[:order_id].blank?
    raise ActiveRecord::RecordNotFound if session[:order_id].to_i != params[:id].to_i

    @order = Order.includes(order_items: { sku: :product }).find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to cart_path, alert: t("flash.orders.not_found")
  end

  private

  def order_params
    params.require(:order).permit(:customer_name, :customer_email)
  end

end

class ApplicationController < ActionController::Base
  helper_method :current_cart, :unpaid_order

  private

  def current_cart
    return if session[:cart_id].blank?

    @current_cart ||= Cart.find_by(id: session[:cart_id])
  end

  def find_or_create_cart
    @current_cart ||= begin
        cart = Cart.find_by(id: session[:cart_id]) if session[:cart_id]
        cart ||= Cart.create
        session[:cart_id] = cart.id
        cart
    end
  end

  # 未支払いの注文を取得
  def unpaid_order
    return if session[:order_id].blank?

    @unpaid_order ||= Order.find_by(id: session[:order_id])
    return unless @unpaid_order&.status_new?

    @unpaid_order
  end
end

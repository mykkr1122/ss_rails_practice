class ApplicationController < ActionController::Base
  helper_method :current_cart

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
end

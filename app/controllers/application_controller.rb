class ApplicationController < ActionController::Base
  helper_method :current_cart

  private

  def current_cart
    @current_cart ||= find_or_create_cart
  end

  def find_or_create_cart
    cart = Cart.find_by(id: session[:cart_id]) if session[:cart_id]
    cart ||= Cart.create
    session[:cart_id] = cart.id
    cart
  end
end

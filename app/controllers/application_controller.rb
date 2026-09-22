class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_cart, :unpaid_order

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def after_sign_in_path_for(resource)
    attach_guest_cart_to_user(resource)
    attach_guest_order_to_user(resource)
    stored_location_for(resource) || orders_path
  end

  def after_sign_up_path_for(resource)
    attach_guest_cart_to_user(resource)
    attach_guest_order_to_user(resource)
    orders_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end

  private

  def current_cart
    @current_cart ||= if user_signed_in?
                        current_user.cart
                      elsif session[:cart_id].present?
                        Cart.find_by(id: session[:cart_id], user_id: nil)
                      end
  end

  def find_or_create_cart
    @current_cart ||= begin
      cart = if user_signed_in?
               current_user.cart || Cart.create!(user: current_user)
             else
               (Cart.find_by(id: session[:cart_id], user_id: nil) if session[:cart_id]) || Cart.create!
             end
      session[:cart_id] = cart.id
      cart
    end
  end

  # 未支払いの注文を取得
  def unpaid_order
    @unpaid_order ||= begin
      order = if user_signed_in?
                current_user.orders.find_by(status: :new)
              elsif session[:order_id].present?
                Order.find_by(id: session[:order_id])
              end
      order if order&.status_new?
    end
  end

  # ゲストユーザーのカートをログインユーザーのカートに紐づけ
  def attach_guest_cart_to_user(user)
    guest = Cart.find_by(id: session[:cart_id], user_id: nil) if session[:cart_id]
    user_cart = user.cart

    if guest && user_cart && guest.id != user_cart.id
      user_cart.merge_from!(guest)
      session[:cart_id] = user_cart.id
    elsif guest
      guest.update!(user: user)
      session[:cart_id] = guest.id
    elsif user_cart
      session[:cart_id] = user_cart.id
    end
  end

  def attach_guest_order_to_user(user)
    return if session[:order_id].blank?

    order = Order.find_by(id: session[:order_id])
    return unless order&.user_id.blank?

    order.update(user: user)
  end
end

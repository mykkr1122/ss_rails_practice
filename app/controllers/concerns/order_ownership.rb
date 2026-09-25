# app/controllers/concerns/order_ownership.rb
# 注文の所有権をチェックするための共通メソッド
module OrderOwnership
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :redirect_order_not_found
  end

  private

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

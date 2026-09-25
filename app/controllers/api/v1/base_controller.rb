class Api::V1::BaseController < Api::BaseController
  before_action :authenticate_user!

  private

  def current_cart_for_api
    @current_cart_for_api ||= current_user.cart || current_user.create_cart!
  end
end

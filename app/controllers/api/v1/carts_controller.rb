class Api::V1::CartsController < Api::V1::BaseController
  # GET /api/v1/cart
  # ログインユーザー自身のカートの中身を返す。
  def show
    render json: current_cart_for_api,
           include: { cart_items: { include: { sku: { include: :product } } } }
  end
end

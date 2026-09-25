class Api::V1::Orders::PaymentsController < Api::V1::BaseController
  before_action :set_order

  # GET /api/v1/orders/:order_id/payment
  # 自分の注文の支払い状況を返す。
  def show
    render json: @order
  end

  # POST /api/v1/orders/:order_id/payment
  # 決済を実行し、注文を完了状態にする。
  def create
    if @order.status_complete?
      render json: { error: { message: t("api.errors.already_paid") } }, status: :unprocessable_entity
      return
    end
    @order.status_complete!
    render json: @order
  end

  private

  def set_order
    @order = current_user.orders.find(params[:order_id])
  end
end

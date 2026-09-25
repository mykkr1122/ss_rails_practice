class Api::V1::Admin::Orders::CompletionsController < Api::V1::BaseController
  before_action :set_order
  before_action :reject_if_completed

  # POST /api/v1/admin/orders/:order_id/completion
  # 管理者が注文を完了状態にする。
  def create
    @order.status_complete!
    render json: @order
  end

  private

  def set_order
    @order = Order.includes(order_items: { sku: :product }).find(params[:order_id])
  end

  def reject_if_completed
    return unless @order.status_complete?

    render json: { error: { message: t("api.errors.already_completed") } }, status: :unprocessable_entity
  end
end

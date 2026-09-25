class Orders::PaymentsController < ApplicationController
  include OrderOwnership

  before_action :require_own_order

  # GET /orders/:order_id/payment
  # 支払い画面を表示する。決済済みなら注文詳細へリダイレクトする。
  def show
    redirect_to order_path(@order) if @order.status_complete?
  end

  # POST /orders/:order_id/payment
  # 決済を実行し、注文を完了状態にする。
  def create
    if @order.status_complete?
      redirect_to order_path(@order), notice: t("flash.orders.pay.already")
      return
    end

    @order.status_complete!
    redirect_to order_path(@order), notice: t("flash.orders.pay.notice")
  end

  private

  def require_own_order
    @order = Order.includes(order_items: { sku: :product }).find(params[:order_id])
    raise ActiveRecord::RecordNotFound unless own_order?(@order)
  end
end

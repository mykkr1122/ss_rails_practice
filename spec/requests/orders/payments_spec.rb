require "rails_helper"

RSpec.describe "Orders::Payments", type: :request do
  def create_order_as_guest
    post cart_items_path, params: {
      product_id: products(:one).id,
      cart_item: { sku_id: skus(:one).id, quantity: 1 }
    }
    post orders_path, params: { order: { customer_name: "山田太郎", customer_email: "yamada@example.com" } }
    Order.last
  end

  describe "GET /orders/:order_id/payment" do
    it "未決済注文の支払い画面が表示できる" do
      order = create_order_as_guest

      get order_payment_path(order)

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /orders/:order_id/payment" do
    it "決済を実行すると注文が完了し、注文詳細へリダイレクトされる" do
      order = create_order_as_guest

      post order_payment_path(order)

      expect(order.reload).to be_status_complete
      expect(response).to redirect_to(order_path(order))
    end

    it "支払い済みの注文に再度支払おうとするとエラーメッセージで注文詳細へ戻る" do
      order = create_order_as_guest
      order.update!(status: :complete)

      post order_payment_path(order)

      expect(response).to redirect_to(order_path(order))
      follow_redirect!
      expect(response.body).to include(I18n.t("flash.orders.pay.already"))
    end
  end
end

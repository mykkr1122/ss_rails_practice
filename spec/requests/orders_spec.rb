require "rails_helper"

RSpec.describe "Orders", type: :request do
  def add_item_to_cart
    post cart_items_path, params: {
      product_id: products(:one).id,
      cart_item: { sku_id: skus(:one).id, quantity: 1 }
    }
  end

  describe "GET /orders" do
    it "未ログインだとログイン画面へリダイレクトされる" do
      get orders_path

      expect(response).to redirect_to(new_user_session_path)
    end

    it "ログインユーザーは自分の注文一覧を見られる" do
      sign_in users(:one)

      get orders_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /orders/new" do
    it "カートが空だとカート画面へリダイレクトされる" do
      get new_order_path

      expect(response).to redirect_to(cart_path)
    end

    it "カートに商品があれば注文確認画面が表示される" do
      add_item_to_cart

      get new_order_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /orders" do
    it "ゲストでもカートから注文を作成し、支払い画面へ遷移する" do
      add_item_to_cart

      expect {
        post orders_path, params: { order: { customer_name: "山田太郎", customer_email: "yamada@example.com" } }
      }.to change(Order, :count).by(1)

      expect(response).to redirect_to(order_payment_path(Order.last))
    end
  end

  describe "GET /orders/:id" do
    it "他人の注文は見られず注文一覧へリダイレクトされる" do
      sign_in users(:one)

      get order_path(orders(:two))

      expect(response).to redirect_to(orders_path)
    end
  end
end

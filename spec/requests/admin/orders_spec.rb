require "rails_helper"

RSpec.describe "Admin::Orders", type: :request do
  describe "GET /admin/orders" do
    it "受注一覧を表示できる" do
      get admin_orders_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admin/orders/:id" do
    it "受注詳細を表示できる" do
      get admin_order_path(orders(:one))

      expect(response).to have_http_status(:success)
    end

    it "存在しない注文は一覧へリダイレクトされる" do
      get admin_order_path(id: 0)

      expect(response).to redirect_to(admin_orders_path)
    end
  end
end

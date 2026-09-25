require "rails_helper"

RSpec.describe "Admin::Orders::Completions", type: :request do
  describe "POST /admin/orders/:order_id/completion" do
    it "未決済の注文を完了にできる" do
      order = orders(:one)

      post admin_order_completion_path(order)

      expect(order.reload).to be_status_complete
      expect(response).to redirect_to(admin_order_path(order))
    end

    it "完了済みの注文は再度完了にできない" do
      order = orders(:two)

      post admin_order_completion_path(order)

      expect(response).to redirect_to(admin_order_path(order))
      follow_redirect!
      expect(response.body).to include(I18n.t("flash.admin.orders.complete.alert"))
    end
  end
end

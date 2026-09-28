require "rails_helper"

RSpec.describe "Api::V1::Admin::Orders::Completions", type: :request do
  describe "POST /api/v1/admin/orders/:order_id/completion" do
    it "新規注文を完了にできる" do
      post "/api/v1/admin/orders/#{orders(:one).id}/completion", headers: auth_headers_for(users(:one))

      expect(response).to have_http_status(:success)
      expect(orders(:one).reload.status_complete?).to be true
    end

    it "完了済みの注文は再度完了にできない" do
      post "/api/v1/admin/orders/#{orders(:two).id}/completion", headers: auth_headers_for(users(:one))

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end

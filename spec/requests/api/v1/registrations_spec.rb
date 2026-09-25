require "rails_helper"

RSpec.describe "Api::V1::Registrations", type: :request do
  describe "POST /api/v1/account" do
    it "新規アカウントを作成し、そのままJWTが発行される" do
      params = {
        user: {
          name: "新規太郎",
          email: "shinki@example.com",
          password: "password",
          password_confirmation: "password"
        }
      }

      post "/api/v1/account", params: params, as: :json

      expect(response).to have_http_status(:created)
      expect(response.headers["Authorization"]).to be_present
    end

    it "パスワード確認が一致しないと作成できない" do
      params = {
        user: {
          name: "失敗太郎",
          email: "fail@example.com",
          password: "password",
          password_confirmation: "different"
        }
      }

      post "/api/v1/account", params: params, as: :json

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /api/v1/account" do
    it "current_passwordが正しければ名前を更新できる" do
      patch "/api/v1/account",
            params: { user: { name: "更新後の名前", current_password: "password" } },
            headers: auth_headers_for(users(:one)), as: :json

      expect(response).to have_http_status(:success)
      expect(users(:one).reload.name).to eq("更新後の名前")
    end

    it "current_passwordが間違っていると更新できない" do
      patch "/api/v1/account",
            params: { user: { name: "更新後の名前", current_password: "wrong" } },
            headers: auth_headers_for(users(:one)), as: :json

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end

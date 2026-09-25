module ApiAuthentication
  def auth_headers_for(user, password: "password")
    post "/api/v1/login", params: { email: user.email, password: password }, as: :json
    { "Authorization" => response.headers["Authorization"] }
  end
end

RSpec.configure do |config|
  config.include ApiAuthentication, type: :request
end

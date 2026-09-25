require "test_helper"

class Api::V1::ProductsControllerTest < ActionDispatch::IntegrationTest
  test "未ログインでも公開商品の一覧が取得できる" do
    get "/api/v1/products"

    assert_response :success
    ids = JSON.parse(response.body).map { |p| p["id"] }
    assert_includes ids, products(:one).id
    assert_not_includes ids, products(:two).id
  end

  test "未ログインでも公開商品の詳細が取得できる" do
    get "/api/v1/products/#{products(:one).id}"

    assert_response :success
  end

  test "非公開商品の詳細は404になる" do
    get "/api/v1/products/#{products(:two).id}"

    assert_response :not_found
  end
end

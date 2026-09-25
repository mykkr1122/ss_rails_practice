require "test_helper"

class Api::V1::CartItemsControllerTest < ActionDispatch::IntegrationTest
  test "公開商品のSKUをカートに追加できる" do
    skus(:one).update!(stock: 10)

    post "/api/v1/cart_items",
         params: { cart_item: { sku_id: skus(:one).id, quantity: 2 } },
         headers: auth_headers_for(users(:one)), as: :json

    assert_response :created
  end

  test "非公開商品のSKUは追加できない" do
    post "/api/v1/cart_items",
         params: { cart_item: { sku_id: skus(:two).id, quantity: 1 } },
         headers: auth_headers_for(users(:one)), as: :json

    assert_response :unprocessable_entity
  end

  test "カート内商品の数量を更新できる" do
    skus(:one).update!(stock: 10)

    patch "/api/v1/cart_items/#{cart_items(:one).id}",
          params: { cart_item: { quantity: 5 } },
          headers: auth_headers_for(users(:one)), as: :json

    assert_response :success
    assert_equal 5, cart_items(:one).reload.quantity
  end

  test "カート内商品を削除できる" do
    delete "/api/v1/cart_items/#{cart_items(:one).id}", headers: auth_headers_for(users(:one))

    assert_response :no_content
  end
end

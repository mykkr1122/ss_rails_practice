require 'test_helper'

class CartItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get cart_items_show_url
    assert_response :success
  end

end

require 'test_helper'

class CartItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sku = skus(:one)
    @product = products(:one)
  end

  test 'should create cart item' do
    assert_difference 'CartItem.count', 1 do
      post cart_items_url, params: {
        product_id: @product.id,
        cart_item: { sku_id: @sku.id, quantity: 1 }
      }
    end

    assert_redirected_to cart_path
    assert_equal I18n.t('flash.cart_items.create.notice'), flash[:notice]
  end

  test 'should update cart item' do
    post cart_items_url, params: {
      product_id: @product.id,
      cart_item: { sku_id: @sku.id, quantity: 1 }
    }
    item = Cart.find(session[:cart_id]).cart_items.find_by!(sku: @sku)
    @sku.update!(stock: 5)

    patch cart_item_url(item), params: { cart_item: { quantity: 2 } }

    assert_redirected_to cart_path
    assert_equal I18n.t('flash.cart_items.update.notice'), flash[:notice]
    assert_equal 2, item.reload.quantity
  end

  test 'should destroy cart item' do
    post cart_items_url, params: {
      product_id: @product.id,
      cart_item: { sku_id: @sku.id, quantity: 1 }
    }
    item = Cart.find(session[:cart_id]).cart_items.find_by!(sku: @sku)

    assert_difference 'CartItem.count', -1 do
      delete cart_item_url(item)
    end

    assert_redirected_to cart_path
    assert_equal I18n.t('flash.cart_items.destroy.notice'), flash[:notice]
  end
end

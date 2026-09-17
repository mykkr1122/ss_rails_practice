class CartsController < ApplicationController
  def show
    @cart = current_cart
    @cart_items = if @cart
                  @cart.cart_items.includes(sku: :product)
                  else
                    CartItem.none
                  end
  end
end

class CartItemsController < ApplicationController
  def create
    product = Product.published.find_by(id: cart_item_params[:product_id])
    item = current_cart.add_product(product, cart_item_params[:quantity])
  
    # エラーがない場合はカートページにリダイレクト
    if item.errors.empty?
      redirect_to cart_path, notice: t('flash.cart_items.create.notice')
    else
      # エラーがある場合は商品詳細ページにリダイレクト
      redirect_to product.present? ? product_path(product) : products_path,
                  alert: item.errors.full_messages.to_sentence
    end
  end
  
  def update
    item = current_cart.cart_items.find(params[:id])
    if item.update(cart_item_update_params)
      redirect_to cart_path, notice: t('flash.cart_items.update.notice')
    else
      # エラーがある場合はカートページにリダイレクト
      redirect_to cart_path, alert: item.errors.full_messages.to_sentence
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to cart_path, alert: t('flash.cart_items.not_found')
  end
  
  def destroy
    item = current_cart.cart_items.find(params[:id])
    if item.destroy
      redirect_to cart_path, notice: t('flash.cart_items.destroy.notice')
    else
      redirect_to cart_path, alert: t('flash.cart_items.destroy.alert')
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to cart_path, alert: t('flash.cart_items.not_found')
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end

  def cart_item_update_params
    params.require(:cart_item).permit(:quantity)
  end
end

class CartItemsController < ApplicationController
  def create
    sku = Sku.joins(:product).merge(Product.published).find_by(id: cart_item_params[:sku_id])
    item = find_or_create_cart.add_sku(sku, cart_item_params[:quantity])
  
    if item.errors.empty?
      redirect_to cart_path, notice: t('flash.cart_items.create.notice')
    else
      product = sku&.product || Product.published.find_by(id: params[:product_id])
      redirect_to product.present? ? product_path(product) : products_path,
                  alert: item.errors.full_messages.to_sentence
    end
  end
  
  def update
    raise ActiveRecord::RecordNotFound if current_cart.blank?
    item = current_cart.cart_items.find(params[:id])
    if item.update(cart_item_update_params)
      redirect_to cart_path, notice: t('flash.cart_items.update.notice')
    else
      redirect_to cart_path, alert: item.errors.full_messages.to_sentence
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to cart_path, alert: t('flash.cart_items.not_found')
  end
  
  def destroy
    raise ActiveRecord::RecordNotFound if current_cart.blank?
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
    params.require(:cart_item).permit(:sku_id, :quantity)
  end

  def cart_item_update_params
    params.require(:cart_item).permit(:quantity)
  end
end

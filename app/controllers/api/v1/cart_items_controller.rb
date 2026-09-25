class Api::V1::CartItemsController < Api::V1::BaseController
  # POST /api/v1/cart_items
  # 公開商品のSKUをカートに追加する。
  def create
    sku = Sku.joins(:product).merge(Product.published).find_by(id: cart_item_params[:sku_id])
    item = current_cart_for_api.add_sku(sku, cart_item_params[:quantity])

    if item.errors.empty?
      render json: item, status: :created
    else
      render json: { error: { messages: item.errors.full_messages } }, status: :unprocessable_entity
    end
  end

  # PATCH /api/v1/cart_items/:id
  # カート内商品の数量を更新する。
  def update
    item = current_cart_for_api.cart_items.find(params[:id])
    if item.update(cart_item_update_params)
      render json: item
    else
      render json: { error: { messages: item.errors.full_messages } }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/cart_items/:id
  # カート内商品を削除する。
  def destroy
    item = current_cart_for_api.cart_items.find(params[:id])
    item.destroy
    head :no_content
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:sku_id, :quantity)
  end

  def cart_item_update_params
    params.require(:cart_item).permit(:quantity)
  end
end

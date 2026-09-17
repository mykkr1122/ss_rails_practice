class ProductsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :redirect_product_not_found
  def index
    @products = Product.published.includes(:skus);
    if params[:q]
      @products = @products.where('name LIKE ?', "%#{params[:q]}%")
    end
  end

  def show
    @product = Product.published.find(params[:id]);
  end

  private

  def redirect_product_not_found
    redirect_to products_path, alert: t('flash.products.not_found')
  end

end

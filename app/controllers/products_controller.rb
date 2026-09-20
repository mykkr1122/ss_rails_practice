class ProductsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :redirect_product_not_found
  
  def index
    @q = Product.published.ransack(search_params)
    @products = @q.result(distinct: true)
                .includes(:skus)
  end

  def show
    @product = Product.published.find(params[:id])
  end

  private

  def redirect_product_not_found
    redirect_to products_path, alert: t('flash.products.not_found')
  end

  def search_params
    params.fetch(:q, {}).permit(:name_cont)
  end

end

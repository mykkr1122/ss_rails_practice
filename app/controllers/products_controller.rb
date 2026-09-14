class ProductsController < ApplicationController
  def index
    @products = Product.published;
    if params[:q]
      @products = @products.where('name LIKE ?', "%#{params[:q]}%")
    end
  end

  def show
    @product = Product.published.find(params[:id]);
  end

end

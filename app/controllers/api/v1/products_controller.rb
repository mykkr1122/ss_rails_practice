class Api::V1::ProductsController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: [:index, :show]

  # GET /api/v1/products
  # 公開商品の一覧を返す。ログイン不要。
  def index
    products = Product.published.includes(:skus)
    render json: products
  end

  # GET /api/v1/products/:id
  # 公開商品の詳細を返す。非公開商品はRecordNotFoundで404になる。
  def show
    product = Product.published.find(params[:id])
    render json: product
  end
end

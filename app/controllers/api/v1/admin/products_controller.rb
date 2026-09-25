class Api::V1::Admin::ProductsController < Api::V1::BaseController
  before_action :set_product, only: [:show, :update, :destroy]

  # GET /api/v1/admin/products
  # 商品一覧を返す。ransackによる検索に対応。
  def index
    q = Product.ransack(search_params)
    products = q.result(distinct: true).includes(:skus)
    render json: products, include: :skus
  end

  # GET /api/v1/admin/products/:id
  # 商品詳細をSKU込みで返す。
  def show
    render json: @product, include: :skus
  end

  # POST /api/v1/admin/products
  # 商品を新規作成する。
  def create
    product = Product.new(product_params)
    if product.save
      render json: product, include: :skus, status: :created
    else
      render json: { error: { messages: product.errors.full_messages } }, status: :unprocessable_entity
    end
  end

  # PATCH /api/v1/admin/products/:id
  # 商品を更新する。
  def update
    if @product.update(product_params)
      render json: @product, include: :skus
    else
      render json: { error: { messages: @product.errors.full_messages } }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/admin/products/:id
  # 商品を削除する。カート・注文に紐づくSKUがある場合は削除できない。
  def destroy
    if @product.destroy
      head :no_content
    else
      render json: { error: { messages: @product.errors.full_messages } }, status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def search_params
    params.fetch(:q, {}).permit(:name_cont)
  end

  def product_params
    params.require(:product).permit(
      :name, :status, :description, :store_id,
      skus_attributes: [:id, :code, :price, :stock, :_destroy]
    )
  end
end

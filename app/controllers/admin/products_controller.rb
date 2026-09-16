class Admin::ProductsController < ApplicationController
    def index
        @products = Product.all;
        if params[:q]
          @products = @products.where('name LIKE ?', "%#{params[:q]}%")
        end
      end
    
    def show
        @product = Product.find(params[:id]);
    end

    def new
        @product = Product.new;
      end
    
      def edit
        @product = Product.find(params[:id]);
      end
    
    def create
        @product = Product.new(product_params);
         if @product.save
          redirect_to [:admin, @product]
         else
          render :new
         end
      end
     
      def update
        @product = Product.find(params[:id]);
        if @product.update(product_params)
         redirect_to [:admin, @product]
        else
          render :edit
        end
      end
    
      def destroy
        product = Product.find(params[:id]);
        product.destroy;
        redirect_to admin_products_path;
      end
    
      private 
      def product_params
        params.require(:product).permit(:name, :price, :stock, :status, :description, :store_id);
      end

      def store_params
        params.require(:store).permit(:name, :store_number);
      end
end

class Admin::ProductsController < ApplicationController

rescue_from ActiveRecord::RecordNotFound, with: :redirect_product_not_found
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
          redirect_to [:admin, @product], notice: t('flash.admin.products.create.notice')
         else
          flash.now[:alert] = t('flash.admin.products.create.alert')
          render :new
         end
      end
     
      def update
        @product = Product.find(params[:id]);
        if @product.update(product_params)
         redirect_to [:admin, @product], notice: t('flash.admin.products.update.notice')
        else
          flash.now[:alert] = t('flash.admin.products.update.alert')
          render :edit
        end
      end
    
      def destroy
        product = Product.find(params[:id]);
        if product.destroy
          redirect_to admin_products_path, notice: t('flash.admin.products.destroy.notice')
        else
        redirect_to admin_products_path, alert: t('flash.admin.products.destroy.alert')
        end
      end
    
      private 

      def redirect_product_not_found
        redirect_to admin_products_path, alert: t('flash.admin.products.not_found')
      end

      def product_params
        params.require(:product).permit(:name, :price, :stock, :status, :description, :store_id);
      end

end

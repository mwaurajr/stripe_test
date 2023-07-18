class User::ProductsController < User::BaseController 
    before_action :check_for_products
    #include CreatePwa
  
    def index
      @products = current_user.products
    end
  
    def show
      @product = Product.find(params[:id])
      #make_pwa if @product.zip_filename.blank?
      #redirect_to root_path + @product.zip_filename
      redirect_to user_products_path
    end
  
    private
  
    def check_for_products
      if current_user and !cookies[:pwa_id].blank?
        product = Product.find( decode_id(cookies[:pwa_id]) )
        if product.created_at >= 30.minutes.ago and product.user_id.blank?
          current_user.products << product 
          cookies[:pwa_id] = nil
        end
      end
    end
  end
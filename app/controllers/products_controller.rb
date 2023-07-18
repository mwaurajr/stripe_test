class ProductsController < ApplicationController 
  def create
    @product = Product.new(product_params)
    @product.user = current_user if current_user

    if @product.save
      if current_user
        redirect_to user_root_path, notice: t('saved_successfully')
      else
        cookies[:pwa_id] = { value: encode_id(@product.id), expires: 30.minutes.from_now }
        redirect_to new_user_registration_path, notice: "Sign up to download the PWA"
      end
    else
      render :new
    end
  end

  private

  def product_params
    params.require(:product).permit(:title, :content)
  end
end
class User::ChargesController < User::BaseController 
    before_action :set_product
    before_action :redirect_if_paid
    layout "stripe/application"
    include StripeMethods 
  
    def new 
    end
  
    def create 
      session = Stripe::Checkout::Session.create({
        line_items: [{
          price: @product.price_id,
          quantity: 1,
        }],
        mode: 'payment',
        customer: current_user.customer_id,
        client_reference_id: @product.product_id,
        success_url: user_charge_success_url(charge_id: @product.id) + "?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: user_charge_cancel_url(charge_id: @product.id),
      })
  
      redirect_to session.url
    end
  
    def success
      session = Stripe::Checkout::Session.retrieve(params[:session_id])
      customer = Stripe::Customer.retrieve(session.customer)
      # is_paid is in concerns/stripe_methods.rb
      @product.update(paid_at: Time.now) if is_paid(session, customer)
    end
  
    def cancel
    end
  
    private
  
    def set_product
      @product = current_user.products.find(params["charge_id"])
    end
  
    def redirect_if_paid
      redirect_to user_root_path unless @product.paid_at.blank?
    end
  end
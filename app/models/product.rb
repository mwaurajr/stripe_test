class Product < ApplicationRecord
    validates :title, uniqueness: { case_sensitive: false }
    belongs_to :user, optional: true
    default_scope { order(created_at: :desc ) }
  
    before_save :set_price
    def set_price
      self.price = 300
      self.subscription_price = 1000
    end
  
    after_save :assign_price_id 
    def assign_price_id
      if self.price_id.blank? and self.product_id.blank?
        product = Stripe::Product.create(id: self.id, name: self.title, type: "service")
        price = Stripe::Price.create(product: product.id, currency: self.currency, unit_amount: self.price, recurring: nil)
        subscription_price = Stripe::Price.create(product: product.id, currency: self.currency, unit_amount: self.subscription_price, recurring: {interval: 'month'})
  
        self.update(price_id: price.id, product_id: product.id, subscription_price_id: subscription_price.id)
      end
    end
  
    def currency
      "KSH"
    end
  
    def in_main_currency(price)
      (price.to_f / 100.0).round(2)
    end
  
    def in_main_currency_humanized(price)
      sprintf("%.2f #{self.currency}",  self.in_main_currency(price) ) #.gsub('.00','')
    end
  
    def price_in_main_currency
      self.in_main_currency(self.price)
    end
  
    def price_humanized
      self.in_main_currency_humanized(self.price)
    end
  
    def subscription_price_in_main_currency
      self.in_main_currency(self.subscription_price)
    end
  
    def subscription_price_humanized
      self.in_main_currency_humanized(self.subscription_price) + " / month"
    end
  
    def is_subscribed
      !self.subscribed_at.blank? and self.unsubscribed_at.blank?
    end
  
    def is_unsubscribed
      self.subscribed_at.blank? and !self.unsubscribed_at.blank?
    end
  
    def was_never_subscribed
      self.subscribed_at.blank? and self.unsubscribed_at.blank?
    end
  end
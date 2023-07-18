class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  default_scope { order(created_at: :desc ) }
  has_many :products

  after_save :assign_customer_id 
  def assign_customer_id
    if self.customer_id.blank? 
      customer = Stripe::Customer.create(email: email)
      self.update(customer_id: customer.id)
    end
  end

  def products_purchased
    self.products.where.not(paid_at: nil)
  end

  def products_subscribed_on
    self.products.where.not(subscribed_at: nil)
  end
end
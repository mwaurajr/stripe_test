class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.integer :price
      t.string :price_id
      t.string :product_id
      t.datetime :paid_at
      t.string :zip_filename
      t.string :subscription_price_id
      t.integer :subscription_price
      t.datetime :subscribed_at
      t.string :subscription_id
      t.datetime :unsubscribed_at

      t.timestamps
    end
  end
end

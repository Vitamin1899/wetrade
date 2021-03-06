class CreateSellers < ActiveRecord::Migration
  def change
    create_table :sellers do |t|
      t.string :name
      t.string :email
      t.string :password_hash
      t.string :firm
      t.string :produce
      t.integer :produce_price
      t.string :wepay_access_token
      t.integer :wepay_account_id

      t.timestamps null: false
    end
  end
end

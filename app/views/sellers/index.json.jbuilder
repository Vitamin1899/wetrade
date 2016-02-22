json.array!(@sellers) do |seller|
  json.extract! seller, :id, :name, :email, :password_hash, :firm, :produce, :produce_price, :wepay_access_token, :wepay_account_id
  json.url seller_url(seller, format: :json)
end

class Seller < ActiveRecord::Base

  validates :password, :presence => true
  validates :password, :length => { :in => 6..200}
  validates :name, :email, :presence => true
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :format => { :with => /@/, :message => " is invalid" }

  def password
    password_hash ? @password ||= BCrypt::Password.new(password_hash) : nil
  end

  def password=(new_password)
    @password = BCrypt::Password.create(new_password)
    self.password_hash = @password
  end

  def self.authenticate(email, test_password)
  seller = Seller.find_by_email(email)
  if seller && seller.password == test_password
    seller
  else
    nil
  end
end
end

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

  # get the authorization url for this farmer. This url will let the farmer
  # register or login to WePay to approve our app.

  # returns a url
  def wepay_authorization_url(redirect_uri)
    Wetrade::Application::WEPAY.oauth2_authorize_url(redirect_uri, self.email, self.name)
  end

  # takes a code returned by wepay oauth2 authorization and makes an api call to generate oauth2 token for this farmer.
  def request_wepay_access_token(code, redirect_uri)
    response = Wetrade::Application::WEPAY.oauth2_token(code, redirect_uri)
    if response['error']
      raise "Error - "+ response['error_description']
    elsif !response['access_token']
      raise "Error requesting access from WePay"
    else
      self.wepay_access_token = response['access_token']
      self.save
    end
  end

  def has_wepay_access_token?
    !self.wepay_access_token.nil?
  end

  # makes an api call to WePay to check if current access token for farmer is still valid
  def has_valid_wepay_access_token?
    if self.wepay_access_token.nil?
      return false
    end
    response = Wetrade::Application::WEPAY.call("/user", self.wepay_access_token)
    response && response["user_id"] ? true : false
  end

end

class SessionsController < ApplicationController

  def new
  end

  def create
    seller = Seller.authenticate params[:email], params[:password]
    if seller
      session[:seller_id] = seller.id
      redirect_to root_path, :notice => "Welcome back to WeTrade"
    else
      redirect_to :login, :alert => "Invalid email or password"
    end
  end

  def destroy
    session[:seller_id] = nil
    redirect_to root_path :notice => "You have been logged out"
  end

end

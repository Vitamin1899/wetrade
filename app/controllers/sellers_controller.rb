class SellersController < ApplicationController
  before_action :set_seller, only: [:show, :edit, :update, :destroy]

  # GET /sellers
  # GET /sellers.json
  def index
    @sellers = Seller.all
  end

  # GET /sellers/1
  # GET /sellers/1.json
  def show
    @seller = Seller.find(params[:id])
    @is_admin = current_user && current_user.id == @seller.id
  end

  # GET /sellers/new
  def new
    if current_user
      redirect_to root_path, :notice => "You are already registered"
    end
    @seller = Seller.new
  end

  # GET /sellers/1/edit
  def edit
    @seller = Seller.find(params[:id])
    if current_user.id != @seller.id
      redirect_to @seller
    end
  end

  # POST /sellers
  # POST /sellers.json
  def create
    @seller = Seller.new(seller_params)

    respond_to do |format|
      if @seller.save
        session[:seller_id] = @seller.id
        format.html { redirect_to @seller, notice: 'Seller was successfully created.' }
        format.json { render :show, status: :created, location: @seller }
      else
        format.html { render :new }
        format.json { render json: @seller.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sellers/1
  # PATCH/PUT /sellers/1.json
  def update
    respond_to do |format|
      if @seller.update(seller_params)
        format.html { redirect_to @seller, notice: 'Seller was successfully updated.' }
        format.json { render :show, status: :ok, location: @seller }
      else
        format.html { render :edit }
        format.json { render json: @seller.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sellers/1
  # DELETE /sellers/1.json
  def destroy
    @seller.destroy
    respond_to do |format|
      format.html { redirect_to sellers_url, notice: 'Seller was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_seller
      @seller = Seller.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def seller_params
      params.require(:seller).permit(:name, :email, :password, :firm, :produce, :produce_price, :wepay_access_token, :wepay_account_id)
    end

    # GET /farmers/oauth/1
    def oauth
      if !params[:code]
        return redirect_to('/')
      end

      redirect_uri = url_for(:controller => 'farmers', :action => 'oauth', :farmer_id => params[:farmer_id], :host => request.host_with_port)
      @farmer = Farmer.find(params[:farmer_id])
      begin
        @farmer.request_wepay_access_token(params[:code], redirect_uri)
      rescue Exception => e
        error = e.message
      end

      if error
        redirect_to @farmer, alert: error
      else
        redirect_to @farmer, notice: 'We successfully connected you to WePay!'
      end
    end

end

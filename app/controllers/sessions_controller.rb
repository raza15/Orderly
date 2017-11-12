class SessionsController < ApplicationController
  before_action :set_session, only: [:show, :edit, :update, :destroy]

  # GET /sessions
  # GET /sessions.json
  def index
    @sessions = Session.all
  end

  # GET /sessions/1
  # GET /sessions/1.json
  def show
  end

  def creditpayment
    cookies.delete :orders
    cookies.delete :coffee_order
    cookies.delete :coffee_quantity
    cookies.delete :coffee_size
  end

  def magic

  end

  def end_transaction
    reset_session
    cookies.delete :orders
    cookies.delete :coffee_order
    cookies.delete :coffee_quantity
    cookies.delete :coffee_size
    cookies.delete :total_cost

    cookies[:orders] = []
    cookies[:coffee_order] = "coffee"
    cookies[:coffee_quantity] = 1
    cookies[:coffee_size] = "medium"
    # cookies[:total_cost] = 0
    session[:order_id] = 5
  end

  def creditpayment_process
    require 'net/http'
    require 'uri'
    require 'json'

    secureNetId = '8011195' # Replace with your own ID
    secureKey = '6kGnYyjuVs4b' # Replace with your own Key
    url = 'https://gwapi.demo.securenet.com/api/Payments/Charge'
    charge = {
      amount: 8.00,
      card: {
        number: '4111111111111111',
        cvv: '123',
        expirationDate: '07/2018',
        address: {
          company: 'Nov8 Inc',
          line1: '123 Main St.',
          city: 'Austin',
          state: 'TX',
          zip: '78759'
        }
      },
      extendedInformation: {
        typeOfGoods: 'PHYSICAL'
      },
      developerApplication: {
        developerId: 12345678,
        version: '1.2'
      }
    }

    uri = URI.parse(url)                       # Parse the URI
    http = Net::HTTP.new(uri.host, uri.port)   # New HTTP connection
    http.use_ssl = true                        # Must use SSL!
    req = Net::HTTP::Post.new(uri.request_uri) # HTTP POST request 
    req.body = charge.to_json                  # Convert hashmap to string
    req["Content-Type"] = 'application/json'   # JSON body
    req.basic_auth secureNetId, secureKey      # HTTP basic auth
    res = http.request(req)                    # Make the call
    res_body = JSON.parse(res.body)            # Convert JSON to hashmap

    puts "http response code: #{res.code}"
    puts "success: #{res_body["success"]}"
    puts "result: #{res_body["result"]}"
    puts "message: #{res_body["message"]}"
    puts "transactionId: #{res_body["transaction"]["transactionId"]}"
  end

  # GET /sessions/new
  def new
    reset_session
    cookies.delete :orders
    cookies.delete :coffee_order
    cookies.delete :coffee_quantity
    cookies.delete :coffee_size
    cookies.delete :total_cost

    cookies[:orders] = []
    cookies[:coffee_order] = "coffee"
    cookies[:coffee_quantity] = 1
    cookies[:coffee_size] = "medium"
    cookies[:total_cost] = 0
    @session = Session.new
    session[:order_id] = 5
  end

  # GET /sessions/1/edit
  def edit
  end

  # POST /sessions
  # POST /sessions.json
  def create
    @session = Session.new(session_params)

    respond_to do |format|
      if @session.save
        format.html { redirect_to @session, notice: 'Session was successfully created.' }
        format.json { render :show, status: :created, location: @session }
      else
        format.html { render :new }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sessions/1
  # PATCH/PUT /sessions/1.json
  def update
    respond_to do |format|
      if @session.update(session_params)
        format.html { redirect_to @session, notice: 'Session was successfully updated.' }
        format.json { render :show, status: :ok, location: @session }
      else
        format.html { render :edit }
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sessions/1
  # DELETE /sessions/1.json
  def destroy
    @session.destroy
    respond_to do |format|
      format.html { redirect_to sessions_url, notice: 'Session was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_session
      @session = Session.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def session_params
      params.require(:session).permit(:order_id)
    end
end

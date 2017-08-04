class UserStocksController < ApplicationController
  before_action :set_user_stock, only: %i[show edit update destroy]

  # GET /user_stocks
  # GET /user_stocks.json
  def index
    @user_stocks = UserStock.all
  end

  # GET /user_stocks/1
  # GET /user_stocks/1.json
  def show
  end

  # GET /user_stocks/new
  def new
    @user_stock = UserStock.new
  end

  # GET /user_stocks/1/edit
  def edit
  end

  # POST /user_stocks
  # POST /user_stocks.json
  def create
    create_user_stock
    respond_to do |format|
      if @user_stock.save
        format.html { redirect_to my_portfolio_path, notice: message(:added, @user_stock.stock.ticker) }
        format.json { render :show, status: :created, location: @user_stock }
      else
        format.html { render :new }
        format.json { render json: @user_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_stocks/1
  # PATCH/PUT /user_stocks/1.json
  def update
    respond_to do |format|
      if @user_stock.update(user_stock_params)
        format.html { redirect_to @user_stock, notice: message(:updated) }
        format.json { render :show, status: :ok, location: @user_stock }
      else
        format.html { render :edit }
        format.json { render json: @user_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_stocks/1
  # DELETE /user_stocks/1.json
  def destroy
    @user_stock.destroy
    respond_to do |format|
      format.html { redirect_to user_stocks_url, notice: message(:destroyed) }
      format.json { head :no_content }
    end
  end

  private

  def create_user_stock
    return new_user_stock_by_id if params[:stock_id].present?
    stock = Stock.find_by_ticker(params[:stock_ticker])
    return new_user_stock(stock) if stock
    stock = Stock.new_from_lookup(params[:stock_ticker])
    return new_user_stock(stock) if stock.save
    flash[:error] = 'Stock is not available'
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user_stock
    @user_stock = UserStock.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_stock_params
    params.require(:user_stock).permit(:user_id, :stock_id)
  end

  def new_user_stock_by_id
    @user_stock = UserStock.new(stock_id: params[:stock_id], user: current_user)
  end

  def new_user_stock(stock)
    @user_stock = UserStock.new(user: current_user, stock: stock)
  end

  def message(type, name = nil)
    message = "Stock was successfully #{type}."
    message = message.split(' ').insert(1, name).join(' ') if name
    message
  end
end

class AccountsController < ApplicationController
  before_action :authenticate_user!, :except => [:new]
  before_action :set_account, only: %i[ show edit update destroy remove_account]
  skip_before_action :verify_authenticity_token, :only => [:remove_account]

  # GET /accounts or /accounts.json
  def index
    if current_user.role == 'admin'
      @accounts = Account.all
    else
      redirect_to account_path(current_user.account)
    end
  end

  # GET /accounts/1 or /accounts/1.json
  def show
    unless current_user.role == 'admin'
      @account = current_user.account
      @portfolio = current_user.account.portfolio
      @market_portfolios = @portfolio.market_portfolios
      @balance = current_user.account.wallet.balance
      @revenue = MarketPortfolio.revenue(@portfolio)
    else
      @account = Account.find(params[:id])
      @portfolio = @account.portfolio
      @market_portfolios = @portfolio.market_portfolios
    end
  end

  # GET /accounts/new
  def new
    authorize Account, :new?
    @account = Account.new
    @account.build_user
    @roles = Account.roles.reject{|x| x == 'admin'}
  end

  # GET /accounts/1/edit
  def edit
    @roles = Account.roles.reject{|x| x == 'admin'}
  end

  # POST /accounts or /accounts.json
  def create
    @account = Account.new(account_params)
    respond_to do |format|
      if @account.save
        format.html { redirect_to @account, notice: "Account was successfully created." }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accounts/1 or /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: "Account was successfully updated." }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1 or /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: "Account was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def remove_account
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: "Account was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def account_params
      params.require(:account).permit(:img, :role, :firstname, :lastname, :address, :contact_number, :is_verified, user_attributes: [:id, :email, :password])
    end
end

class Api::V1::CurrenciesController < Api::V1::BaseController
  before_action :set_currency, only: [:show, :update]
  before_action :authenticate_request!
  after_create :set_currency
  # helper_method :current_user
  # before_action :set_user
  # GET /currencies
  def index
    @currencies = Currency.all

    render json: @currencies
  end

  # GET /currencies/1
  def show
    render json: @currency
  end

  # POST /currencies
  def create
    @currency = Currency.new(currency_params)

    if @currency.save
      render json: @currency, status: :created
    else
      render json: @currency.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /currencies/1
  def update
    if @currency.update(currency_params)
      render json: @currency
    else
      render json: @currency.errors, status: :unprocessable_entity
    end
  end

  # DELETE /currencies/1
  def destroy
    @currency = Currency.with_deleted.find(params[:id])
    if params[:type] == 'normal'
      @currency.destroy
      render json: {success: "Currency deleted and archived"}, status: :ok
    elsif params[:type] == 'forever'
      @currency.really_destroy!
      render json: {success: "Currency permanently deleted"}, status: :ok
    elsif params[:type] == 'undelete'
      @currency.restore
      render json: {success: "Currency restored"}, status: :ok
    end
  end


# Implementing public_activity:
# start with the migration:
# rails g public_activity:migration

# model_name.rb
  # include PublicActivity::Model
  # tracked owner: Proc.new { |controller, model| controller.current_user ? controller.current_user : nil }

# controller.rb
  # def current_user
  #   # @user_id = payload[0]['user_id']
  #   current_user = @current_user
  # end


# finally in config/locales/en.yml
# en:
#   activity:
#     currency:
#       create: 'Currency has been created'
#       update: 'Someone has edited the currency'
#       destroy: 'Some user removed a currency!'



# This method assigns logged in user as current_user, which is later used in the
# model file to assign current_user as the owner of that CRUD action.

  def current_user
    # @user_id = payload[0]['user_id']
    current_user = @current_user
  end

  def current_record
    current_record = @currency if @currency
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_user
    #   @user = @current_user
    # end

    def set_currency
      @currency = Currency.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def currency_params
      params.require(:currency).permit(:name, :symbol)
    end
end

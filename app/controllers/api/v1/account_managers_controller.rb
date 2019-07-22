class Api::V1::AccountManagersController < Api::V1::BaseController
  before_action :set_account_manager, only: [:show, :update, :destroy]

  # GET /account_managers
  def index
    @account_managers = AccountManager.all

    render json: @account_managers
  end

  # GET /account_managers/1
  def show
    render json: @account_manager
  end

  # POST /account_managers
  def create
    @account_manager = AccountManager.new(account_manager_params)

    if @account_manager.save
      render json: @account_manager, status: :created, location: @account_manager
    else
      render json: @account_manager.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /account_managers/1
  def update
    if @account_manager.update(account_manager_params)
      render json: @account_manager
    else
      render json: @account_manager.errors, status: :unprocessable_entity
    end
  end

  # DELETE /account_managers/1
  def destroy
    @account_manager.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account_manager
      @account_manager = AccountManager.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def account_manager_params
      params.require(:account_manager).permit(:full_name)
    end
end

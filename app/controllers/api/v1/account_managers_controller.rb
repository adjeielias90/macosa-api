class Api::V1::AccountManagersController < Api::V1::BaseController
  before_action :set_account_manager, only: [:show, :update, :destroy]
  before_action :authenticate_request!
  # GET /account_managers
  def index
    @account_managers = AccountManager.all

    render json: @account_managers, status: :ok
  end

  # GET /account_managers/1
  def show
    render json: @account_manager
  end

  # POST /account_managers
  def create
    @account_manager = AccountManager.new(account_manager_params)

    if @account_manager.save
      render json: @account_manager, status: :created
    else
      render json: @account_manager.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /account_managers/1
  def update
    if @account_manager.update(account_manager_params)
      render json: @account_manager, status: :ok
    else
      render json: @account_manager.errors, status: :unprocessable_entity
    end
  end

  # DELETE /account_managers/1
  def destroy
    @account_manager = AccountManager.with_deleted.find(params[:id])
    if params[:type] == 'normal'
      @account_manager.destroy
      render json: {success: "Account Manager deleted and archived"}, status: :ok
    elsif params[:type] == 'forever'
      @account_manager.really_destroy!
      render json: {success: "Account Manager permanently deleted"}, status: :ok
    elsif params[:type] == 'undelete'
      @account_manager.restore
      render json: {success: "Account Manager restored"}, status: :ok
    end
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

class Api::V1::ContactsController < Api::V1::BaseController
  before_action :set_contact, only: [:show, :update]#, :destroy]
  # before_action :authenticate_request!
  # Authorize request before processing
  before_action :authenticate_request!

  # GET /contacts
  def index
    @contacts = Contact.all.order(created_at: :DESC).page params[:page]

    # Custom Pagination
    @per_page = 10
    total_records = Contact.count
    # @orders = Order.all.page params[:page]

    if (total_records % @per_page) == 0
      total_pages = total_records/@per_page
    else
      total_pages = (total_records/@per_page) + 1
    end
    @meta = { total_pages: total_pages, total_records: total_records }

    render json: @contacts, meta: @meta status: :ok
  end

  # GET /contacts/1
  def show
    render json: @contact, status: :ok
  end

  # POST /contacts
  def create
    if @current_user.is_admin?
      @contact = Contact.new(contact_params)

      if @contact.save
        render json: @contact, status: :created
      else
        render json: {errors: @contact.errors}, status: :unprocessable_entity
      end
    else
      render json: {errors:'You are not authorized to perform this action.'}, status: :unauthorized
    end
  end

  # PATCH/PUT /contacts/1
  def update
    if @current_user.is_admin?
      if @contact.update(contact_params)
        render json: @contact, status: :ok
      else
        render json: @contact.errors, status: :unprocessable_entity
      end
    else
      render json: {errors:'You are not authorized to perform this action.'}, status: :unauthorized
    end
  end

  # DELETE /contacts/1
  def destroy
    if @current_user.is_admin?
      @contact = Contact.with_deleted.find(params[:id])
      if params[:type] == 'normal'
        @contact.destroy
        render json: {success: "Contact deleted and archived"}, status: :ok
      elsif params[:type] == 'forever'
        @contact.really_destroy!
        render json: {success: "Contact permanently deleted"}, status: :ok
      elsif params[:type] == 'undelete'
        @contact.restore
        render json: {success: "Contact restored"}, status: :ok
      end
    else
      render json: {errors:'You are not authorized to perform this action.'}, status: :unauthorized
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def contact_params
      params.require(:contact).permit(:title, :firstname, :lastname, :phone, :email, :background, :Contact_id)
    end
end

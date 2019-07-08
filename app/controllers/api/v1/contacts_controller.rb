class Api::V1::ContactsController < Api::V1::BaseController
  before_action :set_contact, only: [:show, :update, :destroy]

  # Authorize request before processing
  # before_action :authenticate_request!

  # GET /contacts
  def index
    @contacts = Contact.all

    render json: {success: "Test passed"}, status: :ok
  end

  # GET /contacts/1
  def show
    render json: @contact
  end

  # POST /contacts
  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      render json: @contact, status: :created, location: @contact
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contacts/1
  def update
    if @contact.update(contact_params)
      render json: @contact
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contacts/1
  def destroy
    @contact.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def contact_params
      params.require(:data).require(:attributes).permit(:title, :firstname, :lastname, :phone, :email, :background, :company_id)
    end
end

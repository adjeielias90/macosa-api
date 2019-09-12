class Api::V1::BaseController < ApplicationController
  # Rescue exception to handle exceptions our own way ;)
  # rescue_from ::Exception, :with => :rescue_exception
  include PublicActivity::StoreController 
  rescue_from ActiveRecord::RecordNotFound , :with => :raise_not_found_error
  #rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
  rescue_from ActionController::RoutingError, :with => :routing_error

  def undefined_route
    routing_error
  end
  
  def current_user
    load_current_user!
  end
    


  protected
    def allow_access
      return true
    end

    def deny_access
      render :json => {
        :success  =>  false,
        :message  =>  "Access denied"
      }.to_json

      return false
    end

    def routing_error(exception = nil)
      # deliver_exception_notification(exception) if exception

      render :json => {
        :success => false,
        :message => "Invalid/Undefined API Endpoint"
      }.to_json
    end

    def record_not_found(exception)
      # deliver_exception_notification(exception)

      render :json => {
        :success => false,
        :message => "Record not found"
      }.to_json
    end

    def rescue_exception(exception)
      # deliver_exception_notification(exception)

      render :json => {
        :success => false,
        :message => "Exception occured",
        :exception => exception.inspect
      }.to_json
    end
end

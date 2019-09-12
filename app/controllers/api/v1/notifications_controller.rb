  class Api::V1::OrdersController < Api::V1::BaseController
    before_action :authenticate_request!

    # Also in your controller:
    # notifications_controller.rb
    def index
      @activities = PublicActivity::Activity.all
      render json: @activities
    end
  end
  class Api::V1::NotificationsController < Api::V1::BaseController
    before_action :authenticate_request!


    # [How to] Set the Activity's owner to current_user by default
      # Include PublicActivity::StoreController in your ApplicationController like this:
      # class ApplicationController < ActionController::Base
      #   include PublicActivity::StoreController
      # end
      # Use Proc in :owner attribute for tracked class method in your desired model. For example:
      # class Article < ActiveRecord::Base
      #   tracked owner: Proc.new{ |controller, model| controller.current_user }
      # end
      # # Note: current_user applies to Devise, if you are using a different authentication gem or your own code, change the current_user to a method you use.

    # Also in your controller:
    # notifications_controller.rb
    def index
      @activities = PublicActivity::Activity.all.order(created_at: :DESC).page(params[:page]).per(10)
      render json: @activities
    end
  end
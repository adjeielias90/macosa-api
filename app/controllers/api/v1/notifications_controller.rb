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
      # Custom Pagination


      # end
      if params.has_key?(:user_id) != nil
        if params[:user_id] != nil
          @activities = PublicActivity::Activity.where(owner_id: params[:user_id]).page(params[:page])
          @per_page = 25
          total_records = @activities.count
          # @orders = Order.all.page params[:page]

          if (total_records % @per_page) == 0
            total_pages = total_records/@per_page
          else
            total_pages = (total_records/@per_page) + 1
          end
          @meta = { total_pages: total_pages, total_records: total_records }
        else
          @activities = PublicActivity::Activity.all.order(created_at: :DESC).page(params[:page]).per(25)

          @per_page = 25
          total_records = PublicActivity::Activity.count
          # @orders = Order.all.page params[:page]

          if (total_records % @per_page) == 0
            total_pages = total_records/@per_page
          else
            total_pages = (total_records/@per_page) + 1
          end
          @meta = { total_pages: total_pages, total_records: total_records }
        end
      else
        @activities = PublicActivity::Activity.all.order(created_at: :DESC).page(params[:page]).per(25)
        @per_page = 25
        total_records = PublicActivity::Activity.count
        # @orders = Order.all.page params[:page]

        if (total_records % @per_page) == 0
          total_pages = total_records/@per_page
        else
          total_pages = (total_records/@per_page) + 1
        end
        @meta = { total_pages: total_pages, total_records: total_records }
      end


      # render json: @activities
      render json: @activities, meta: @meta, status: :ok

    end
  end
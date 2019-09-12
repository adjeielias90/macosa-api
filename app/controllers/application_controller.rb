class ApplicationController < ActionController::API
  include ActionController::Helpers
  require 'json_web_token'
  helper_method :current_user





  protected
    # Validates the token and user and sets the current_user scope

    def current_user
      if authenticate_request!
        @user_id = payload[0]['user_id']
        current_user = User.find_by(id: @user_id)
      else
        return invalid_authentication
      end
    end



    end
    
    def authenticate_request!
      if !payload
        return invalid_token
      elsif !JsonWebToken.valid_payload(payload.first)
        return invalid_authentication
      end

      load_current_user!
      invalid_authentication unless current_user
    end

    # Returns 401 response. To handle malformed / invalid requests.
    def invalid_authentication
      render json: {authentication_error: 'Access denied. No token present in auth headers'}, status: :unauthorized
    end


    def invalid_token
      render json: {invalid_token: 'Token expired or invalid'}, status: :unauthorized
    end


  private
    # def current_user
    #   @user_id = payload[0]['user_id']
    #   current_user = User.find_by(id: @user_id)
    # end

    # Deconstructs the Authorization header and decodes the JWT token.
    def payload
      auth_header = request.headers['Authorization']
      token = auth_header.split(' ').last
      JsonWebToken.decode(token)
      rescue
      nil
    end


    # Sets the current_user with the user_id from payload
    def load_current_user!
      @user_id = payload[0]['user_id']
      @current_user = User.find_by(id: @user_id)
      # current_user= User.includes(:orders).find_by(id: @user_id)
    end
end

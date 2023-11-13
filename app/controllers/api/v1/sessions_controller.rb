class Api::V1::SessionsController < ApplicationController
  before_action :authenticate_request, only: [:destroy, :current_user]

  def create
    # Handle the login logic
    entity = Entity.find_by(user_name: params[:user_name])

    if entity && is_password_matched?(params[:password], entity.password)
      # Log the user in and return the authentication token
      entity.generate_authentication_token
      entity.save
      response_json(token: entity.authentication_token)
    else
      raise Rest::Errors::AuthenticationError.new(401, {}, "Invalid email/password combination")
    end
  end

  def current_user
    user = @current_user
    if user
      response_json user.as_json, 200
    else
      response_json [], 404, {}
    end
  end

  def destroy
    @current_user.update(authentication_token: nil)
    response_json([], 200)
  end


  private

  def is_password_matched?(password, hash)
    BCrypt::Password.new(hash) == password
  end
end

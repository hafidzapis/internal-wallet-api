class ApplicationController < ActionController::API
  rescue_from Rest::Errors::AuthenticationError, with: :custom_service_error
  rescue_from Rest::Errors::TransactionError, with: :custom_service_error
  rescue_from Rest::Errors::WalletError, with: :custom_service_error

  def response_json(data, code = 200, errors = {})
    envelope = {
      data: data,
      meta: {
        code: code,
        errors: errors
      }
    }

    render json: envelope, status: code
  end

  private

  def authenticate_request
    @current_user = find_current_user
    raise Rest::Errors::AuthenticationError.new(401, {}, "Not Authorized") unless @current_user
  end

  def find_current_user
    # Extract and validate the token from the request headers, params, or wherever you store it
    authentication_token = request.headers['Authorization']&.split(' ')&.last
    return unless authentication_token

    # Find the user based on the token
    Entity.find_by(authentication_token: authentication_token)
  end

  def render_envelope(err_code, exception, data = {})
    envelope = {
      data: data,
      meta: {
        code: err_code,
        error_message: exception.message.to_s,
        error_type: exception.class.to_s
      }
    }
    envelope
  end

  def custom_service_error(exception)
    render json: render_envelope(exception.code, Exception.new(exception.message), exception.data), status: exception.code
  end

end

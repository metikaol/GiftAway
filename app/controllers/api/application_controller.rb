class Api::ApplicationController < ApplicationController

  skip_before_action :verify_authenticity_token

  rescue_from StandardError, with: :standard_error
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  def not_found
    render(
      json: {
        errors: [{
          type: "NotFound"
        }]
      },
      status: :not_found # :not_found is alias for 404 in rails
    )
  end

  def current_user
    token = request.headers["AUTHORIZATION"]

    begin
      payload = JWT.decode(
        token,
        Rails.application.secrets.secret_key_base
      )&.first

      @user ||= User.find_by(id: payload["id"])
    rescue JWT::DecodeError => error
      nil
    end
  end
  helper_method :current_user

  private
  def authenticate_user!
    unless current_user.present?
      render(
        json: {
          errors: [{
            type: "Unauthorized"
          }]
        },
        status: :unauthorized # alias for status code 401
      )
    end
  end

  def encode_token(payload = {}, exp = 24.hours.from_now)
  payload[:exp] = exp.to_i # important!!! otherwise token never expires!
  JWT.encode(
    payload,
    Rails.application.secrets.secret_key_base
  )
  end

  protected
  # protected is like private except that it prevents descendent
  # classes from using protected methods.
  def record_not_found(error)
    render(
      json: {
        errors: [{
          type: error.class.to_s,
          message: error.message
        }]
      },
      status: :not_found
    )
  end

  def standard_error(error)
    logger.error "#{error.class.to_s} #{error.message}"
    logger.error error.backtrace.join("\r\n")

    render(
      json: {
        errors: [{
          type: error.class.to_s,
          message: error.message
        }]
      },
      status: :internal_server_error # alias for status code 500
    )
  end

  def record_invalid(error)
    record = error.record
    errors = record.errors.map do |field, message|
      {
        type: error.class.to_s,
        record_type: record.class.to_s,
        field: field,
        message: message
      }
    end

    render(
      json: {
        errors: errors
      },
      status: :unprocessable_entity # alias for status code 422
    )
  end
end

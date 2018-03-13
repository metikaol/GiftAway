class Api::ApplicationController < ApplicationController
  # When making POST requests to our controllers Rails
  # will require an authenticity token in the params
  # to verify that POST originated from one of its
  # forms. This doesn't make for a JSON Web API therefore
  # we'll skip that code.
  skip_before_action :verify_authenticity_token

  def current_user
    token = request.headers["AUTHORIZATION"]

    # The decoded token will be array containing
    # the payload and the JWT header in that order.
    begin
      payload = JWT.decode(
        token,
        Rails.application.secrets.secret_key_base
      )&.first

      # To get a value from payload, make sure to use
      # strings to access the keys. The payload's hash's
      # keys are all strings and not symbols.
      @user ||= User.find_by(id: payload["id"])
    rescue JWT::DecodeError => error
      nil
    end
  end
  helper_method :current_user

  private
  def authenticate_user!
    head :unauthorized unless current_user.present?
  end
end

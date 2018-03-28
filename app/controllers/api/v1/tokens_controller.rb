class Api::V1::TokensController < Api::ApplicationController
  # Users must make HTTP requests to this action with
  # their email & password to receive a token (to sign in).
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      render json: {
        jwt: encode_token({
            id: user.id,
            first_name: user.first_name,
            last_name: user.last_name,
            full_name: user.full_name
        })
      }
    else
      render(
        json: {
          errors: [{
            type: "NotFound"
          }]
        },
        status: :not_found
      )
    end
  end

end

class Api::V1::UsersController < Api::ApplicationController

  def create
    user = User.new user_params
    if user.save
      render json: {
        jwt: encode_token({
            id: user.id,
            first_name: user.first_name,
            last_name: user.last_name,
            full_name: user.full_name
        })
      }
    else
      
      error_data = user.errors.messages
      errors = []
      error_data.each do |k, v|
        error_obj = {}
        error_obj["field"] = k

        error = []
        error << v

        error_obj["message"] = error
        errors << error_obj
      end

      render(
        json: errors
      )
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :contact_number, :password, :password_confirmation
    )
  end

end

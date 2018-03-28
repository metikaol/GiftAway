class UsersController < ApplicationController
  def new
  @user = User.new
end

def create
@user = User.new user_params

if @user.save

  session[:user_id] = @user.id
  flash[:notice] = "Thank you for signing in!"
  redirect_to posts_path
else
# render json: params
render :new
end
end


private
def user_params
  params.require(:user).permit(:first_name, :last_name, :email, :password, :address, :contact_number, :password_confirmation)
end
end

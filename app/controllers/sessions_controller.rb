class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(email: session_params[:email])


    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      flash.now[:notice] = 'Thank you for signing in!'
      redirect_to posts_path
    else

      flash.now[:alert] = 'Wrong email or password!'
      render :new
    end
  end


  def destroy
  session[:user_id] = nil
  flash.now[:notice] = 'Signed out!'
  redirect_to posts_path
  end



  private
  def session_params
    params.require(:session).permit(:email, :password)
  end


  end

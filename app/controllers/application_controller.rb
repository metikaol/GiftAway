class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private
def new_post
  @new_post ||= Post.new
end
helper_method :new_post

def user_signed_in?
current_user.present?
# session[:user_id].present?
end
helper_method :user_signed_in?

def current_user
if session[:user_id].present?
@current_user ||= User.find_by(id: session[:user_id])
# ☝️OR-EQUAL only assigns to variable if variable is `nil`
# @current_user = @current_user || User.find(session[:user_id]))
end
end
helper_method :current_user
# `helper_method` makes a controller method available to all
# views (or templates)

def authenticate_user!
unless user_signed_in?
flash[:alert] = "You must sign in or sign up first"
redirect_to new_session_path
end
end


end

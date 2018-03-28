class PostsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize_user!, only: [:edit, :update, :destroy]



def show
  @post = Post.find params[:id]

  @answer = Answer.new

  if @post.user == current_user
    @answers = @post.answers.order(created_at: :desc)
  else
    @answers = @post.answers.where(user: current_user).order(created_at: :desc)
  end
end

def index
  # byebug
  @posts = Post.all
  if params[:search1].present?
    @posts = Post.search(params[:search1]).order("created_at DESC")
  elsif params[:search2].present?
    @posts = Post.near(params[:search2], 50, :order => "distance").limit(10)
  else
    @posts = Post.all.order("created_at DESC")
  end
end


def new
  # render plain: 'ok'
  @post = Post.new
end


def create
   @post = Post.new post_params
   @post.user = current_user

   if @post.save
     redirect_to posts_path
   else
     render :new
   end
 end


def edit
  @post = Post.find params[:id]
end

def update
  @post = Post.find params[:id]

  if @post.update post_params
    redirect_to post_path(@post)
  else
    render :edit
  end
end

def destroy
  @post = Post.find params[:id]
  @post.destroy
  redirect_to posts_path
end


 private

def post_params
  params.require(:post).permit(:title, :body, :img, :address)
end


def authorize_user!
 @post = Post.find params[:id]
 unless can?(:manage, @post)
   flash[:alert] = "Access Denied!"
   redirect_to post_path(@post)
 end
end

end

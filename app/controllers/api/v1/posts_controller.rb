class Api::V1::PostsController < Api::ApplicationController
    before_action :authenticate_user!, except: [:index]
    before_action :find_post, only: [:show, :update, :destroy]
    # /api/v1/posts
    # /api/v2/posts
    def index
      posts = Post.order(created_at: :desc)
      render json: posts
    end

    def show
      render json: @post
    end

    def create
      post = Post.new post_params
      post.user = current_user
      post.save
      render json: {id: post.id}
    end

    private
    def find_post
      @post = Post.find params[:id]
    end

    def post_params
      params.require(:post).permit(:title, :body)
    end
  end

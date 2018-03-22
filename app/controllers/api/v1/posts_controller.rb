class Api::V1::PostsController < Api::ApplicationController
    before_action :authenticate_user!, except: [:index]
    before_action :find_post, only: [:show, :update, :destroy]
    # /api/v1/posts
    # /api/v2/posts
    def index
      byebug

      if params[:search1].present? && params[:search2].present?
        posts = Post.near(params[:search2], 50).search(params[:search1]).order("created_at DESC")
      elsif params[:search1].present?
        posts = Post.search(params[:search1]).order("created_at DESC")
      elsif params[:search2].present?
        posts = Post.near(params[:search2], 50)
      else
        posts = Post.all.order("created_at DESC")
      end
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


    def edit
      @post = Post.find params[:id]
    end

    def update
      @post = Post.find params[:id]

      if @post.update post_params
        # redirect_to post_path(@post)
        render json: @post
      else
        render json: @post.errors
      end
    end

    def destroy
    @post.destroy
    end

    private
    def find_post
      @post = Post.find params[:id]
    end

    def post_params
      params.require(:post).permit(
        [ :address,
          :title,
          :body,
          albums_attributes: %I[
          id
          photo
          _destroy
          ]
        ]
      )
    end
  end

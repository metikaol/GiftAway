class Api::V1::PostsController < Api::ApplicationController
    before_action :authenticate_user!, except: [:index]
    before_action :find_post, only: [:show, :update, :destroy]
    before_action :authorize_user!, only: [:destroy]

    def index
      if params[:search_item].present? && params[:search_location].present?
        posts = Post.near(params[:search_location], 50).search(params[:search_item]).order("created_at DESC")
      elsif params[:search_item].present?
        posts = Post.search(params[:search_item]).order("created_at DESC")
      elsif params[:search_location].present?
        posts = Post.near(params[:search_location], 50)
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
      post.save!
      render json: {id: post.id}
    end

    def update
      @post = Post.find params[:id]

      if @post.update post_params
        render json: @post
      else
        render json: @post.errors, status: :unprocessable_entity
      end
    end

    def destroy
    @post.destroy
    end

    private
    def find_post
      @post = Post.find params[:id]
    end

    def authorize_user!
      unless can?(:manage, @post)
        render json: {errors: "Access Denied"}
      end
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

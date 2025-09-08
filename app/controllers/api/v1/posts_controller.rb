module Api
  module V1
    class PostsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_post, only: [:show, :update, :destroy]
      before_action :authorize_user!, only: [:update, :destroy]

      # GET /posts
      def index
        posts = Post.page(params[:page]).per(params[:per_page] || 10)
        render json: posts.as_json(
          only: [:id, :title, :body, :created_at, :updated_at],
          methods: [:image_urls],
          include: {
            user: {
              only: [:id, :email, :created_at]
            },
          comments: {
              only: [:id, :body, :created_at],
              include: {
                user: {
                  only: [:id, :email]
                }
              }
            }
          }
        )
      end

      # GET /posts/:id
      def show
        render json: @post.as_json(
          only: [:id, :title, :body, :created_at, :updated_at],
          methods: [:image_urls],
          include: {
            user: {
              only: [:id, :email, :created_at]
            },
            comments: {
              only: [:id, :body, :created_at],
              include: {
                user: {
                  only: [:id, :email]
                }
              }
            }
          }
        )
      end

      # POST /posts
      def create
        post = current_user.posts.build(post_params)
        if post.save
          render json: { status: 201, message: 'Post created', data: post }, status: :created
        else
          render json: { status: 422, message: post.errors.full_messages.to_sentence }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /posts/:id
      def update

        if params[:remove_images] == 'true'
          @post.images.purge
        end

        if params[:post] && @post.update(post_params)
          render json: @post
        elsif !params[:post]
          render json: { message: 'Images removed successfully.' }, status: :ok
        else
          render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /posts/:id
      def destroy
        @post.destroy
        render json: { message: 'Post deleted successfully.' },status: :ok
      end

      private

      def set_post
        @post = Post.find_by(id: params[:id])
        render json: { error: "Post not found" }, status: :not_found unless @post
      end

      def authorize_user!
        unless @post.user_id == current_user.id || current_user.admin?
          render json: { error: "Unauthorized" }, status: :unauthorized
        end
      end

      def post_params
        params.require(:post).permit(:title, :body, images: [])
      end
    end
  end
end

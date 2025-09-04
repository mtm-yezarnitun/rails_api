# app/controllers/api/v1/comments_controller.rb
module Api
  module V1
    class CommentsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_post
      before_action :set_comment, only: [:destroy]
      before_action :authorize_comment_owner!, only: [:destroy]

      def index
        comments = @post.comments.includes(:user)
        render json: comments, include: :user
      end

      # POST /api/v1/posts/:post_id/comments
      def create
        comment = @post.comments.build(comment_params.merge(user: current_user))
        if comment.save
          render json: comment, status: :created
        else
          render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/posts/:post_id/comments/:id
      def destroy
        @comment.destroy
        head :no_content
      end

      private


      def set_post
        @post = Post.find_by(id: params[:post_id])
        render json: { error: "Post not found" }, status: :not_found unless @post
      end

      def set_comment
        @comment = @post.comments.find_by(id: params[:id])
        render json: { error: "Comment not found" }, status: :not_found unless @comment
      end

      def authorize_comment_owner!
        unless @comment.user_id == current_user.id
          render json: { error: "Unauthorized" }, status: :unauthorized
        end
      end

      def comment_params
        params.require(:comment).permit(:body)
      end
    end
  end
end

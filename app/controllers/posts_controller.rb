class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :authorize_user!, only: [:update, :destroy]

  # GET /posts
  def index
    posts = Post.all
    render json: posts
  end

  # GET /posts/:id
  def show
    render json: @post
  end

  # POST /posts
  def create
    post = current_user.posts.build(post_params)
    if post.save
      render json: post, status: :created
    else
      render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/:id
  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /posts/:id
  def destroy
    @post.destroy
    head :no_content
  end

  private

  def set_post
    @post = current_user.posts.find_by(id: params[:id])
    render json: { error: "Post not found" }, status: :not_found unless @post
  end

  def authorize_user!
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end

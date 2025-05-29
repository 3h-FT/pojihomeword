class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  

  def index
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:user).order("created_at desc").page(params[:page]).per(10)
  end

  def post_favorites
    @q = current_user.favorite_posts.ransack(params[:q])
    @post_favorites = @q.result(distinct: true).includes(:user).order("created_at desc").page(params[:page]).per(10)
    @post_favorites_count = current_user.favorite_posts.count
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: "投稿しました"
    else
      flash.now[:alert] = "投稿できません"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "編集しました"
    else
      flash.now[:alert] = "編集できません"
      render :edit, status: :unprocessable_entity
    end
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy!
    redirect_to posts_path, alert: "投稿を削除しました", status: :see_other
  end

  private

  def post_params
    params.require(:post).permit(:post_word, :caption)
  end
end

class Admin::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :if_not_admin
  before_action :set_post, only: [ :show, :edit, :update, :destroy ]

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to admin_posts_path(@post), notice: "投稿を更新しました"
    else
      flash.now[:alert] = "投稿の更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to admin_posts_path, alert: "投稿を削除しました"
  end

  private

  def if_not_admin
    redirect_to root_path, alert: "管理者専用ページです" unless current_user&.admin?
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:post_word, :caption)
  end
end

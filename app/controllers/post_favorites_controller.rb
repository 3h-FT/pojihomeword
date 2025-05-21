class PostFavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    current_user.post_bookmark(@post)
  end

  def destroy
    @post = current_user.post_favorites.find(params[:id]).post
    current_user.unpost_bookmark(@post)
  end
end

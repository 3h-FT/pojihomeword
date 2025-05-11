class CommentsController < ApplicationController

  def edit
    @comment = current_user.comments.find(params[:id])
    @post = @comment.post
  end

def update
  @comment = current_user.comments.find(params[:id])
  if @comment.update(comment_update_params)
    redirect_to post_path(@comment.post), notice: "コメントを編集しました"
  else
    @post = @comment.post
    flash.now[:alert] = "コメントを編集できません"
    render :edit, status: :unprocessable_entity
  end
end

def create
  @comment = current_user.comments.build(comment_create_params)
  if @comment.save
    redirect_to post_path(@comment.post), notice: 'コメントを投稿しました'
  else
    @post = Post.find(params[:post_id]) 
    flash.now[:alert] = "コメントを投稿できません"
    render 'posts/show', status: :unprocessable_entity
  end
end

def destroy
  @comment = current_user.comments.find(params[:id])
  post = @comment.post
  @comment.destroy
  redirect_to post_path(post), alert: "コメントを削除しました"
end

  private


def comment_create_params
  params.require(:comment).permit(:body).merge(post_id: params[:post_id])
end

def comment_update_params
  params.require(:comment).permit(:body, :post_id)
end
end
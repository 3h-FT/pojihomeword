class CommentsController < ApplicationController
  def edit
    @comment = current_user.comments.find(params[:id])
    @post = @comment.post
  end

  def update
    @comment = current_user.comments.find(params[:id])
    if @comment.update(comment_update_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to post_path(@comment.post), notice: "コメントを更新しました" }
      end
    else
      @post = @comment.post
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("comment-form-#{@comment.id}", partial: "comments/form", locals: { comment: @comment, post: @post }) }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def create
    @comment = current_user.comments.build(comment_create_params)
    @comment.save
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
  end

  private


  def comment_create_params
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end

  def comment_update_params
    params.require(:comment).permit(:body, :post_id)
  end
end

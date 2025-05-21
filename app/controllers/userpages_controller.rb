class UserpagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @q = current_user.positive_words.ransack(params[:q])
    @searched_words = @q.result(distinct: true).includes(:situation, :target)

    favorited_ids = current_user.favorited_words.pluck(:positive_word_id)
    @favorited_words = @searched_words.where(id: favorited_ids)
    @custom_words = @searched_words.where(is_custom: true).where.not(id: favorited_ids)

    @favorited_word_ids = favorited_ids
    @favorited_words_count = favorited_ids.size
    @custom_words_count = @custom_words.count
    @known_word_count = @favorited_words_count + @custom_words_count

    @favorited_words_page = @favorited_words.page(params[:favorited_page]).per(10)
    if @favorited_words_page.out_of_range? && @favorited_words_page.total_pages > 0
      redirect_to userpages_path(tab: "favorite", favorited_page: @favorited_words_page.total_pages)
    end
    @custom_words_page = @custom_words.page(params[:custom_page]).per(10)
    @active_tab = params[:tab] || "all"
  end

  def edit
    @positive_word = current_user.positive_words.find(params[:id])
    @active_tab = params[:tab] || "all"  # タブを保持するため
  end

  def update
    @positive_word = current_user.positive_words.find(params[:id])
    original_tab = params[:tab] || "all"

            success = if @positive_word.is_custom?
      @positive_word.update(positive_word_params)
    else
      @positive_word.update(positive_word_params.except(:is_custom))
    end

    if success
      notice_message = @positive_word.is_custom? ? "カスタムワードを編集しました" : "お気に入りワードを編集しました"
      redirect_to userpages_path(tab: original_tab), notice: notice_message
    else
      flash.now[:alert] = "ワードを編集できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def create
    @positive_word = current_user.positive_words.new(positive_word_params)
    @positive_word.is_custom = true if params[:positive_word][:is_custom] == "true"

    if @positive_word.save
      redirect_to userpages_path, notice: "ワードを追加しました"
    else
      redirect_to userpages_path, alert: "ワードの追加に失敗しました"
    end
  end

  def destroy
    @custom_word = current_user.positive_words.find(params[:id])
    @custom_word.delete
    redirect_to userpages_path, alert: "ワードを削除しました"
  end

  private

  def positive_word_params
    params.require(:positive_word).permit(:word, :is_custom)
  end
end

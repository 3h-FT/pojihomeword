class UserpagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @q = current_user.positive_words.ransack(params[:q])
    @searched_words = @q.result(distinct: true).includes(:situation, :target)

    @favorited_words = @searched_words.where(id: current_user.favorited_words.pluck(:positive_word_id))
    @custom_words = @searched_words.where(is_custom: true)

    @favorited_word_ids = current_user.favorited_words.pluck(:positive_word_id)

    @favorited_words_count = current_user.favorited_words.count
    @custom_words_count = current_user.positive_words.where(is_custom: true).count
    @known_word_count = @favorited_words_count + @custom_words_count

    @favorited_words_page = @favorited_words.page(params[:favorited_page]).per(10)
    @custom_words_page = @custom_words.page(params[:custom_page]).per(10)
    @active_tab = params[:tab] || "all"
  end

  def create
    @positive_word = current_user.positive_words.new(positive_word_params)
    @positive_word.is_custom = true

    if @positive_word.save
      redirect_to userpages_path, notice: "ポジティブワードを追加しました！"
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

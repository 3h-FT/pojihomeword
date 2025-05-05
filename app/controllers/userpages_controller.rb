class UserpagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @q = WordFavorite.ransack(params[:q])
    @favorited_words = @q.result(distinct: true).includes(:positive_word).order(created_at: :desc).map(&:positive_word)
    @favorited_word_ids = current_user.favorited_words.pluck(:positive_word_id)

    @custom_words = current_user.positive_words.where(is_custom: true)

    @known_word_count = @favorited_words.count + @custom_words.count
  end
  
  def create
    @positive_word = current_user.positive_words.new(positive_word_params)
    @positive_word.is_custom = true
  
    if @positive_word.save
      redirect_to userpages_path, notice: 'ポジティブワードを追加しました！'
    else
     redirect_to userpages_path, alert: 'ワードの追加に失敗しました'
    end
  end
  

  def destroy
    @custom_word = current_user.positive_words.find(params[:id])
    @custom_word.delete
    redirect_to userpages_path, alert: 'ワードを削除しました'
  end

  private
  
  def positive_word_params
    params.require(:positive_word).permit(:word, :is_custom)
  end
end
class UserpagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @q = WordFavorite.ransack(params[:q])
    @favorited_words = @q.result(distinct: true)
                         .includes(:positive_word)
                         .order(created_at: :desc)
                         .map(&:positive_word)


    @favorited_word_ids = current_user.favorited_words.pluck(:positive_word_id)
  end
end

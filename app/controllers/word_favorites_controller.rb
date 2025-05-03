class WordFavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @positive_word = PositiveWord.find(params[:positive_word_id])
    current_user.bookmark(@positive_word)
  end

  def destroy
    @positive_word = current_user.word_favorites.find(params[:id]).positive_word
    current_user.unbookmark(@positive_word)
  end
end

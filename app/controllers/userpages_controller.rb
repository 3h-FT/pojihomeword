class UserpagesController < ApplicationController
    before_action :authenticate_user!

    def index
      @favorited_words = current_user.word_favorites.includes(:positive_word).order(created_at: :desc).map(&:positive_word)
      end
end

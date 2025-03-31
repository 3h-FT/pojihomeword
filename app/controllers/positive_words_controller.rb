class PositiveWordsController < ApplicationController
  before_action :authenticate_user!

  def index
    @targets = Target.all
    @situations = Situation.where(target_id: params[:target_id])
    @positive_words = PositiveWord.where(situation_id: params[:situation_id])
  end
end
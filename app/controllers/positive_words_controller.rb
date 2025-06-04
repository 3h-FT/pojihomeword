class PositiveWordsController < ApplicationController
  def index
    set_meta_tags title: "サンプルページ"
    @targets = Target.all
    @situations = params[:target_id].present? ? Situation.where(target_id: params[:target_id]) : []

    @positive_words = []
    if params[:target_id].present? && params[:situation_id].present?
      @positive_words = PositiveWord.where(target_id: params[:target_id], situation_id: params[:situation_id])
    end
  end
end

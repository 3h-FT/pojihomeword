class PositiveWordsController < ApplicationController
  def index
    set_meta_tags title: "サンプルページ"
    # is_seeded: true の Target のみを取得
    @targets = Target.where(is_seeded: true).all
    @situations = params[:target_id].present? ? Situation.where(target_id: params[:target_id], is_seeded: true) : []

    @positive_words = []
    if params[:target_id].present? && params[:situation_id].present?
      @positive_words = PositiveWord.where(target_id: params[:target_id], situation_id: params[:situation_id])
    end
  end
end
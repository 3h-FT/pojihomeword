class Userpages::WordFetcher
  attr_reader :searched_words, :favorited_words, :custom_words, :favorited_ids

  def initialize(user, params)
    @user = user
    @params = params
    @favorited_ids = user.favorited_words.pluck(:positive_word_id)
    run_query
  end

  private

  def run_query
    q = @user.positive_words.ransack(@params[:q])
    @searched_words = q.result(distinct: true).includes(:situation, :target).order(created_at: :desc)
    @favorited_words = @searched_words.where(id: favorited_ids)
    @custom_words = @searched_words.where(is_custom: true).where.not(id: favorited_ids)
  end
end

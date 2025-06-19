class Userpages::AutocompleteQuery
  def initialize(user, keyword)
    @user = user
    @keyword = keyword.to_s.strip
    @favorited_ids = user.favorited_words.pluck(:positive_word_id)
  end

  def call
    q = @user.positive_words.ransack(word_cont: @keyword)
    searched = q.result(distinct: true).includes(:situation, :target)
    fav = searched.where(id: @favorited_ids)
    custom = searched.where(is_custom: true).where.not(id: @favorited_ids)
    (fav + custom).uniq.first(10)
  end
end

class Userpages::WordFetcher
  attr_reader :searched_words, :favorited_words, :custom_words, :favorited_ids

  def initialize(words_scope, params)
    @params = params
    user = words_scope.first&.user
    @favorited_ids = user ? (words_scope.pluck(:id) & user.favorited_words.pluck(:positive_word_id)) : []
    @searched_words = words_scope.includes(:situation, :target)
    @favorited_words = @searched_words.where(id: @favorited_ids)
    @custom_words = @searched_words.where(is_custom: true).where.not(id: @favorited_ids)
  end
end

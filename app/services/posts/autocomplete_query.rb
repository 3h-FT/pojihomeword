module Posts
  class AutocompleteQuery
    def initialize(base_relation, keyword)
      @base_relation = base_relation
      @keyword = keyword.to_s.strip
    end

    def call
      @base_relation.where("post_word LIKE :kw OR caption LIKE :kw", kw: "%#{@keyword}%").limit(10)
    end
  end
end

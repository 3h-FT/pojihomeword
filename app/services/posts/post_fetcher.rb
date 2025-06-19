module Posts
  class PostFetcher
    def initialize(base_relation, params)
      @base_relation = base_relation
      @params = params
    end

    def call
      q = @base_relation.ransack(@params[:q])
      q.result(distinct: true)
       .includes(:user)
       .order(created_at: :desc)
       .page(@params[:page])
    end
  end
end

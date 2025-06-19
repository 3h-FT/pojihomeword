class UserpagesController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def index
    set_meta_tags title: "ユーザーページ"
    filter = params[:filter] || "all"
    
    #検索フォーム
    @q = current_user.positive_words.ransack(params[:q])
    word_data = Userpages::WordFetcher.new(current_user, params)

    #ワードのカウント数
    @favorited_words = word_data.favorited_words
    @custom_words    = word_data.custom_words
    @favorited_word_ids = word_data.favorited_ids
    @favorited_words_count = @favorited_word_ids.size
    @custom_words_count    = @custom_words.count
    @known_word_count      = @favorited_words_count + @custom_words_count

    #ワード種類のフィルター
    @words = case filter
             when "favorite" then @favorited_words
             when "custom"   then @custom_words
             else
               @favorited_words
             end

    #ページネーションの設定
    paginate_words
  end

  def autocomplete
    @results = Userpages::AutocompleteQuery.new(current_user, params[:q]).call
    render partial: "autocomplete_results", locals: { positive_words: @results }
  end

  def show
    set_meta_tags title: "ワード詳細"
    @positive_word = PositiveWord.find(params[:id])
    @show_edit_form = params[:edit].present?
    prepare_meta_tags(@positive_word) 
  end

  def edit
    @positive_word = current_user.positive_words.find(params[:id])
    render partial: "edit_form", locals: { positive_word: @positive_word }
  end

  def update
    @positive_word = current_user.positive_words.find(params[:id])
    if @positive_word.update(positive_word_params)
      render partial: "userpages/custom_words/word_updata", locals: { positive_word: @positive_word }
    else
      render partial: "edit_form", locals: { positive_word: @positive_word }, status: :unprocessable_entity, alert: "ワードの更新に失敗しました"
    end
  end

  def create
    @positive_word = current_user.positive_words.new(positive_word_params.merge(is_custom: params[:positive_word][:is_custom] == "true"))
    if @positive_word.save
      redirect_to userpages_path, notice: "ワードを追加しました"
    else
      redirect_to userpages_path, alert: "ワードの追加に失敗しました"
    end
  end

  def destroy
    @custom_word = current_user.positive_words.find(params[:id])
    @custom_word.destroy!
    word_data = Userpages::WordFetcher.new(current_user, params)

    #Turboのためワードのカウント数を再度取得
    @custom_words = word_data.custom_words
    @favorited_word_ids = word_data.favorited_ids
    @favorited_words_count = @favorited_word_ids.size
    @custom_words_count = @custom_words.count
    @known_word_count = @favorited_words_count + @custom_words_count

    #Turboのためワードのページネーションの設定を再度取得
    @custom_words_page = @custom_words.page(params[:custom_page])
    if @custom_words_page.out_of_range? && @custom_words_page.total_pages.positive?
      @custom_words_page = @custom_words.page(@custom_words_page.total_pages)
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to userpages_path, alert: "ワードを削除しました" }
    end
  end

  private

  def positive_word_params
    params.require(:positive_word).permit(:word, :is_custom)
  end

  def paginate_words
    @favorited_words_page = @favorited_words.page(params[:favorited_page])
    if @favorited_words_page.out_of_range? && @favorited_words_page.total_pages.positive?
      redirect_to userpages_path(favorited_page: @favorited_words_page.total_pages) && return
    end

    @custom_words_page = @custom_words.page(params[:custom_page])
    if @custom_words_page.out_of_range? && @custom_words_page.total_pages.positive?
      redirect_to userpages_path(custom_page: @custom_words_page.total_pages) && return
    end
  end

  def prepare_meta_tags(positive_word)
    # このimage_urlにMiniMagickで設定したOGPの生成した合成画像を代入する
    image_url = "#{request.base_url}/images/ogp.png?text=#{CGI.escape(positive_word.word)}&v=#{positive_word.updated_at.to_i}"
    set_meta_tags og: {
                    site_name: "ポジほめワード",
                    title: positive_word.word,
                    description: "ユーザーによるポジティブなワード",
                    type: "website",
                    url: request.original_url,
                    image: image_url,
                    locale: "ja-JP"
                  },
                  twitter: {
                    card: "summary_large_image",
                    image: image_url
                  }
  end
end

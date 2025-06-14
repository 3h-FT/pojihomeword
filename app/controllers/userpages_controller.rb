class UserpagesController < ApplicationController
  before_action :authenticate_user!, except: [ :show ]

  def index
    set_meta_tags title: "ユーザーページ"
    filter = params[:filter] || "all"

    @q = current_user.positive_words.ransack(params[:q])
    @searched_words = @q.result(distinct: true).includes(:situation, :target).order("created_at desc")

    favorited_ids = current_user.favorited_words.pluck(:positive_word_id)
    @favorited_words = @searched_words.where(id: favorited_ids)
    @custom_words = @searched_words.where(is_custom: true).where.not(id: favorited_ids)

    @favorited_word_ids = favorited_ids
    @favorited_words_count = favorited_ids.size
    @custom_words_count = @custom_words.count
    @known_word_count = @favorited_words_count + @custom_words_count

  case filter
  when "favorite"
    @words = @searched_words.where(id: favorited_ids)
  when "custom"
    @words = @searched_words.where(is_custom: true).where.not(id: favorited_ids)
  else
    # all
    @custom_words = @searched_words.where(is_custom: true).where.not(id: favorited_ids)
    @favorited_words = @searched_words.where(id: favorited_ids)
  end

    @favorited_words_page = @favorited_words.page(params[:favorited_page])
    if @favorited_words_page.out_of_range? && @favorited_words_page.total_pages > 0
      redirect_to userpages_path(favorited_page: @favorited_words_page.total_pages)
    end

    @custom_words_page = @custom_words.page(params[:custom_page])
    if @custom_words_page.out_of_range? && @custom_words_page.total_pages > 0
      redirect_to userpages_path(custom_page: @custom_words_page.total_pages)
    end
  end

  def autocomplete
    keyword = params[:q].to_s.strip

    # 検索用のransackオブジェクト
    @q = current_user.positive_words.ransack(word_cont: keyword)
    @searched_words = @q.result(distinct: true).includes(:situation, :target)

    # お気に入りワードのIDリストを取得
    favorited_ids = current_user.favorited_words.pluck(:positive_word_id)

    # お気に入り登録済みワードだけ抽出
    favorited_words = @searched_words.where(id: favorited_ids)

    # カスタムワード（お気に入り登録以外）を抽出
    custom_words = @searched_words.where(is_custom: true).where.not(id: favorited_ids)

    # お気に入り優先でマージし10件までに絞る
    @results = (favorited_words + custom_words).uniq.first(10)

    # partialに渡す変数名はpositive_wordsに合わせる（partialの変数名に依存）
    render partial: "autocomplete_results", locals: { positive_words: @results }
  end

  def show
    set_meta_tags title: "ワード詳細"
    @positive_word = PositiveWord.find(params[:id])
    prepare_meta_tags(@positive_word) # メタタグを設定する。
    @show_edit_form = params[:edit].present?
  end

  def edit
   @positive_word = current_user.positive_words.find(params[:id])
    render partial: "edit_form", locals: { positive_word: @positive_word  }
  end

  def update
    @positive_word = current_user.positive_words.find(params[:id])
    if @positive_word.update(positive_word_params)
      render partial: "userpages/custom_words/word_updata", locals: { positive_word: @positive_word }
    else
      render partial: "edit_form", locals: { positive_word: @positive_word }, status: :unprocessable_entity, alert: "ワードの追加に失敗しました"
    end
  end

  def create
    @positive_word = current_user.positive_words.new(positive_word_params)
    @positive_word.is_custom = true if params[:positive_word][:is_custom] == "true"

    if @positive_word.save
      redirect_to userpages_path, notice: "ワードを追加しました"
    else
      redirect_to userpages_path, alert: "ワードの追加に失敗しました"
    end
  end

  def destroy
    @custom_word = current_user.positive_words.find(params[:id])
    @custom_word.destroy!

    favorited_ids = current_user.favorited_words.pluck(:positive_word_id)
    @q = current_user.positive_words.ransack(params[:q])
    @searched_words = @q.result(distinct: true).includes(:situation, :target)
    @custom_words = @searched_words.where(is_custom: true).where.not(id: favorited_ids)

    # ページ計算
    @custom_words_page = @custom_words.page(params[:custom_page])
    if @custom_words_page.out_of_range? && @custom_words_page.total_pages > 0
      @custom_words_page = @custom_words.page(@custom_words_page.total_pages) # 最後のページに戻す
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

  def prepare_meta_tags(positive_word)
    # このimage_urlにMiniMagickで設定したOGPの生成した合成画像を代入する
    image_url = "#{request.base_url}/images/ogp.png?text=#{CGI.escape(positive_word.word)}"
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

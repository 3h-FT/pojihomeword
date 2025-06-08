class PostsController < ApplicationController
  before_action :authenticate_user!, except: [ :show ]
  # 設定したprepare_meta_tagsをprivateにあってもpostコントローラー以外にも使えるようにする
  helper_method :prepare_meta_tags


  def index
    set_meta_tags title: "みんなのポジほめワード"
    @q = Post.ransack(params[:q])
    @posts = @q.result(distinct: true).includes(:user).order("created_at desc").page(params[:page]).per(10)
  end

  def post_favorites
    set_meta_tags title: "お気に入り登録ページ"
    @q = current_user.favorite_posts.ransack(params[:q])
    @post_favorites = @q.result(distinct: true).includes(:user).order("created_at desc").page(params[:page]).per(10)
    @post_favorites_count = current_user.favorite_posts.count
  end

  def autocomplete
    keyword = params[:q].to_s.strip
    @posts = Post.where("post_word LIKE :kw OR caption LIKE :kw", kw: "%#{keyword}%").limit(10)

    render partial: "autocomplete_results", locals: { posts: @posts }
  end

  def favorites_autocomplete
    keyword = params[:q].to_s.strip
    @posts = current_user.favorite_posts
                        .where("post_word LIKE :kw OR caption LIKE :kw", kw: "%#{keyword}%")
                        .limit(10)

    render partial: "autocomplete_results", locals: { posts: @posts }
  end

  def new
    set_meta_tags title: "新規投稿作成"
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: "投稿しました"
    else
      flash.now[:alert] = "投稿できません"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    set_meta_tags title: "投稿詳細"
    @post = Post.find(params[:id])
    prepare_meta_tags(@post) # メタタグを設定する。

    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(created_at: :desc)
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "編集しました"
    else
      flash.now[:alert] = "編集できません"
      render :edit, status: :unprocessable_entity
    end
  end

  def edit
    set_meta_tags title: "投稿の編集"
    @post = current_user.posts.find(params[:id])
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy!
    
    respond_to do |format|
      format.html { redirect_to posts_path, alert: "投稿を削除しました", status: :see_other }
      format.turbo_stream
    end
  end

  private

  def post_params
    params.require(:post).permit(:post_word, :caption)
  end

  def prepare_meta_tags(post)
    # このimage_urlにMiniMagickで設定したOGPの生成した合成画像を代入する
    image_url = "#{request.base_url}/images/ogp.png?text=#{CGI.escape(post.post_word)}"
    set_meta_tags og: {
                    site_name: "ポジほめワード",
                    title: post.post_word,
                    description: "ユーザーによるポジティブなワードの投稿",
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

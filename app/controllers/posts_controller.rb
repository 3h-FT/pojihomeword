class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def index
    set_meta_tags title: "みんなのポジほめワード"
   
    #検索フォーム
    @q = Post.ransack(params[:q])
    @posts = Posts::PostFetcher.new(Post.all, params).call

    # ページ数が減って、現在のページが存在しない場合は最後のページへ
    if @posts.out_of_range? && @posts.total_pages > 0
      redirect_to posts_path(page: @posts.total_pages)
    end
  end

  def post_favorites
    set_meta_tags title: "お気に入り登録ページ"

    @q = current_user.favorite_posts.ransack(params[:q])
    @post_favorites = Posts::PostFetcher.new(current_user.favorite_posts, params).call
    
    # お気に入りのワード数
    @post_favorites_count = current_user.favorite_posts.count

    if @post_favorites.out_of_range? && @post_favorites.total_pages > 0
      redirect_to favorites_posts_path(page: @post_favorites.total_pages)
    end
  end

  def autocomplete
    @posts = Posts::AutocompleteQuery.new(Post.all, params[:q]).call
    render partial: "autocomplete_results", locals: { posts: @posts }
  end

  def favorites_autocomplete
    @posts = Posts::AutocompleteQuery.new(current_user.favorite_posts, params[:q]).call
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
    prepare_meta_tags(@post) #OGPの設定
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

    #Turboのためワードのページネーションの設定を再度取得
    @posts = Posts::PostFetcher.new(Post.all, params).call
    if @posts.out_of_range? && @posts.total_pages > 0
      @posts = Posts::PostFetcher.new(Post.all, params.merge(page: @posts.total_pages)).call
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to posts_path, alert: "削除しました" }
    end
  end

  private

  def post_params
    params.require(:post).permit(:post_word, :caption)
  end

  def prepare_meta_tags(post)
    image_url = "#{request.base_url}/images/ogp.png?text=#{CGI.escape(post.post_word)}&v=#{post.updated_at.to_i}"
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

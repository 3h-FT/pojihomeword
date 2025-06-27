class AiMessagesController < ApplicationController
  before_action :authenticate_user!, except: [ :show ]

  def new
    set_meta_tags title: "ワード生成"
    @word_id = params[:word_id]
    @target = params[:target]
    @situation = params[:situation]
    @positive_word = PositiveWord.find_by(id: @word_id) || PositiveWord.new
  end

  def generate
    target, situation = find_or_create_target_and_situation
    if target.nil? || situation.nil?
      return render_missing_input
    end

    ai_message = AiMessagesGenerator.call(
      target_name: target.name,
      situation_name: situation.name
    )

    @positive_word = current_user.positive_words.create!(
      target: target,
      situation: situation,
      word: ai_message
    )

    respond_to do |format|
      format.html {
        redirect_to new_ai_message_path(
          word_id: @positive_word.id,
          target: target.name,
          situation: situation.name
        )
      }
      format.json { render json: { word_id: @positive_word.id } }
    end
  end

  def show
    set_meta_tags title: "ワード詳細"
    @positive_word = PositiveWord.find(params[:id])
    prepare_meta_tags(@positive_word)
    @show_edit_form = params[:edit].present?
  end

  def edit
    @positive_word = current_user.positive_words.find(params[:id])
    render partial: "edit_form", locals: { positive_word: @positive_word }
  end

  def update
    @positive_word = current_user.positive_words.find(params[:id])

    target_name = params[:positive_word][:target].to_s.strip
    situation_name = params[:positive_word][:situation].to_s.strip

    target = Target.find_or_create_by(name: target_name)
    situation = Situation.find_or_create_by(name: situation_name)

    if @positive_word.update(
        word: params[:positive_word][:word],
        target: target,
        situation: situation
      )
      # リダイレクト先を分岐
      render partial: "word_updata", locals: { positive_word: @positive_word }
    else
      render partial: "edit_form", locals: { positive_word: @positive_word }, status: :unprocessable_entity, alert: "ワードを編集できません"
    end
  end

  private

  def find_or_create_target_and_situation
    target_name = params[:positive_word][:target].to_s.strip
    situation_name = params[:positive_word][:situation].to_s.strip

    return [ nil, nil ] if target_name.blank? || situation_name.blank?

    target = Target.find_or_create_by(name: target_name, is_seeded: false)
    situation = Situation.find_or_create_by(name: situation_name, is_seeded: false)

    [ target, situation ]
  end

  def render_missing_input
    respond_to do |format|
      format.html {
        redirect_to new_ai_message_path(error: "対象人物とシチュエーションは必須です。")
      }
      format.json {
        render json: { error: "対象人物とシチュエーションは必須です。" }, status: :unprocessable_entity
      }
    end
  end

  def prepare_meta_tags(positive_word)
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
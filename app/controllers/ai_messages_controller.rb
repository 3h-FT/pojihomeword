class AiMessagesController < ApplicationController
  before_action :authenticate_user!, except: [ :show ]
  helper_method :prepare_meta_tags

  def new
    set_meta_tags title: "ワード生成"

    @word_id = params[:word_id]
    @target = params[:target]
    @situation = params[:situation]

    @positive_word = PositiveWord.find_by(id: @word_id) || PositiveWord.new
  end

  def generate
    # if user_reached_limit?
    #   respond_to do |format|
    #     format.html {
    #       redirect_to new_ai_message_path(error: "一日の生成回数制限に達しました(上限3回)")
    #     }
    #     format.json {
    #       render json: { error: "一日の生成回数制限に達しました(上限3回)" }, status: :forbidden
    #     }
    #   end
    #   return
    # end

    target_name = params[:positive_word][:target].to_s.strip
    situation_name = params[:positive_word][:situation].to_s.strip

    if target_name.blank? || situation_name.blank?
      respond_to do |format|
        format.html {
          redirect_to new_ai_message_path(error: "対象人物とシチュエーションは必須です。")
        }
        format.json {
          render json: { error: "対象人物とシチュエーションは必須です。" }, status: :unprocessable_entity
        }
      end
      return
    end

    target = Target.find_or_create_by(name: target_name)
    situation = Situation.find_or_create_by(name: situation_name)

    @positive_word = PositiveWord.new(
      target: target,
      situation: situation,
      user: current_user
    )

    if @positive_word.valid?
      # --- AIメッセージ生成用プロンプトとAPI呼び出し (将来的に有効化予定) ---
      # prompt = "#{target.name}が#{situation.name}ときに贈る、ほめたり、肯定したりなどポジティブになれる会話文のような短いメッセージを1つ考えてください。出力はそのメッセージ本文のみを日本語で返してください。番号付け、複数回答、説明や挨拶などは不要です。過去に生成されたメッセージと重複しないようにしてください。"
      #
      # client = OpenAI::Client.new
      # response = client.chat(
      #   parameters: {
      #     model: "gpt-4.1-mini",
      #     messages: [ { role: "user", content: prompt } ],
      #     temperature: 0.8
      #   }
      # )
      #
      # ai_message = response.dig("choices", 0, "message", "content")

      ai_message = "シチュエーションでポジティブなメッセージを送ります！" # ダミー出力（開発用）

      @positive_word.word = ai_message
      @positive_word.save!

      respond_to do |format|
        format.html {
          redirect_to new_ai_message_path(
            word_id: @positive_word.id,
            target: target_name,
            situation: situation_name
          )
        }
        format.json {
          render json: { word_id: @positive_word.id }
        }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    set_meta_tags title: "ワード詳細"
    @positive_word = PositiveWord.find(params[:id])
    prepare_meta_tags(@positive_word) # メタタグを設定する。
    if params[:from] == "userpages"  # 編集時のリダイレクト先を分岐のため
    end
  end

  def edit
    set_meta_tags title: "ワードを編集"
    @positive_word = current_user.positive_words.find(params[:id])
    @from = params[:from]
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
      if params[:from] == "userpages"
        redirect_to userpages_path(anchor: "favorited_words"), notice: "ワードを編集しました"
      else
        redirect_to new_ai_message_path(
        word_id: @positive_word.id,
        target: target.name,
        situation: situation.name
        ), notice: "ワードを編集しました"
      end
    else
      flash.now[:alert] = "ワードを編集できません"
      render :edit, status: :unprocessable_entity
    end
  end


  private

  def user_reached_limit?
    current_user.positive_words.where(created_at: Time.zone.today.all_day).count >= 3
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

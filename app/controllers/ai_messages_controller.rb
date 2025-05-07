class AiMessagesController < ApplicationController
  before_action :authenticate_user!

  def new
    @word_id = params[:word_id]
    @target = params[:target]
    @situation = params[:situation]

    @positive_word = PositiveWord.find_by(id: @word_id) || PositiveWord.new
  end

  def generate
    # if user_reached_limit?
    # respond_to do |format|
    # format.html {
    # redirect_to new_ai_message_path(error: "一日の生成回数制限に達しました(上限3回)")
    # }
    # format.json {
    # render json: { error: "一日の生成回数制限に達しました(上限3回)" }, status: :forbidden
    # }
    # end
    # return
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
      # prompt = "#{target.name}が#{situation.name}ときに贈る、ほめたり、肯定したりなどポジティブになれる会話文のような短いメッセージを1つ考えてください。出力はそのメッセージ本文のみを日本語で返してください。番号付け、複数回答、説明や挨拶などは不要です。過去に生成されたメッセージと重複しないようにしてください。"

      # client = OpenAI::Client.new
      # response = client.chat(
      # parameters: {
      # model: "gpt-4.1-mini",
      # messages: [ { role: "user", content: prompt } ],
      # temperature: 0.8
      # }
      # )

      # ai_message = response.dig("choices", 0, "message", "content")
      ai_message = "シチュエーションでポジティブなメッセージを送ります！"

      @positive_word.word = ai_message
      @positive_word.save!

      respond_to do |format|
        format.html {
          redirect_to new_ai_message_path(
            word_id: @positive_word.id,
            target: params[:positive_word][:target],
            situation: params[:positive_word][:situation]
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

  def word_favorites
    @favorited_words = current_user.favorited_words.includes(:positive_word)
  end

  private

  def user_reached_limit?
    current_user.positive_words.where(created_at: Time.zone.today.all_day).count >= 3
  end
end

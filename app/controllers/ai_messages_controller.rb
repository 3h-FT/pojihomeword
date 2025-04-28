class AiMessagesController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def generate
    # ユーザーが1日に3回まで生成できるように制限をかける
    if user_reached_limit?
      respond_to do |format|
        format.html { redirect_to new_ai_message_path(error: '一日の生成回数制限に達しました(上限3回)') }
        format.json { render json: { error: '一日の生成回数制限に達しました(上限3回)' }, status: :forbidden }
      end
      return
    end

    target = Target.find_or_create_by(name: params[:target])
    situation = Situation.find_or_create_by(name: params[:situation])

    prompt = "#{target.name}が#{situation.name}ときに贈る、ほめたり、肯定したりなどポジティブになれる会話文のような短いメッセージを1つ考えてください。出力はそのメッセージ本文のみを日本語で返してください。番号付け、複数回答、説明や挨拶などは不要です。過去に生成されたメッセージと重複しないようにしてください。"

     client = OpenAI::Client.new
     response = client.chat(
       parameters: {
         model: "gpt-4.1-mini",
         messages: [{ role: "user", content: prompt }],
         temperature: 0.8
       }
     )
     @message = response.dig("choices", 0, "message", "content")
    
    current_user.positive_words.create(target: target, situation: situation, word: @message)

    respond_to do |format|
      format.html { redirect_to new_ai_message_path(message: @message, target: params[:target], situation: params[:situation]) }
      format.json { render json: { word: @message } }
    end
  end

  private

  # ユーザーが1日にメッセージ生成を3回以上行っていないかチェック
  def user_reached_limit?
    current_user.positive_words.where(created_at: Time.zone.today.all_day).count >= 3
  end
end
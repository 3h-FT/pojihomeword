class AiMessagesGenerator
  def self.call(target_name:, situation_name:)
    prompt = "#{target_name}が#{situation_name}ときに贈る、ほめたり、肯定したりなどポジティブになれる会話文のような短いメッセージまたはワードを1つ考えてください。出力はそのメッセージ、またはワードの本文のみを日本語で返してください。親しみやすいカジュアルな口調で書いてください。マジではいらないです。番号付け、複数回答、説明や挨拶などは不要です。過去に生成されたメッセージ・ワードと重複しないようにしてください。"

    client = OpenAI::Client.new
    response = client.chat(
      parameters: {
        model: "gpt-4.1-mini",
        messages: [ { role: "user", content: prompt } ],
        temperature: 0.9
      }
    )

    response.dig("choices", 0, "message", "content")
  end
end

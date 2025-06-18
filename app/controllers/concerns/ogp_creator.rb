class OgpCreator
  require "mini_magick"
  BASE_IMAGE_PATH = "./app/assets/images/ogp.png"
  GRAVITY = "center"
  TEXT_POSITION = "0,0"
  FONT = "./app/assets/fonts/MPLUSRounded1c-Regular.ttf"
  FONT_SIZE = 50
  INDENTION_COUNT = 12
  ROW_LIMIT = 3

  def self.build(text)
    text = prepare_text(text)
    image = MiniMagick::Image.open(BASE_IMAGE_PATH)
    image.combine_options do |config|
      config.font FONT
      config.fill "black"
      config.gravity GRAVITY
      config.pointsize FONT_SIZE
      config.draw "text #{TEXT_POSITION} '#{text}'"
    end
  end

  private
  def self.prepare_text(text)
    chunks = text.to_s.scan(/.{1,#{INDENTION_COUNT}}/)
    if chunks.size > ROW_LIMIT
      chunks = chunks[0...ROW_LIMIT]
      # 最後の行の末尾を「…」で置き換える（全角省略記号を使用）
      last_line = chunks.last
      chunks[-1] = last_line[0...-1] + "…" if last_line.length >= 1
    end
    chunks.join("\n")
  end
end

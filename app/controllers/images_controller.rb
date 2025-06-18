class ImagesController < ApplicationController
  skip_before_action :require_login, raise: false

  def ogp
    text = ogp_params[:text]
    image = OgpCreator.build(text).tempfile.open.read

    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "0"

    send_data image, type: "image/png", disposition: "inline"
  end

  private

  def ogp_params
    params.permit(:text)
  end
end

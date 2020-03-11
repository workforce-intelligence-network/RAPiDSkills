class VuejsController < ApplicationController
  layout false

  def index
    response.headers["Cache-Control"] = "private, max-age=0, no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "0"
    render file: "#{Rails.root}/vue/dist/index.html"
  end
end

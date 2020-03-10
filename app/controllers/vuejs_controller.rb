class VuejsController < ApplicationController
  layout false

  def index
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "0"
    render file: "#{Rails.root}/vue/dist/index.html"
  end
end

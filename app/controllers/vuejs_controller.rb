class VuejsController < ApplicationController
  layout false

  def index
    render file: "#{Rails.root}/vue/dist/index.html"
  end
end

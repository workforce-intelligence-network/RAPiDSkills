class VuejsController < ApplicationController
  def index
    render file: "#{Rails.root}/vue/dist/index.html"
  end
end

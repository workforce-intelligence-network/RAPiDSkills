class VuejsController < ApplicationController
  def index
    render file: "#{Rails.root}/app/lib/vuejs/dist/index.html"
  end
end

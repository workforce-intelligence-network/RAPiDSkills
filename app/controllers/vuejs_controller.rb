class VuejsController < ApplicationController
  layout false

  def index
    render text: File.read("#{Rails.root}/vue/dist/index.html")
  end
end

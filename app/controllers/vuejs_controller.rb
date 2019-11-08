class VuejsController < ApplicationController
  def index
    render file: "#{Rails.root}/client/dist/index.html"
  end
end

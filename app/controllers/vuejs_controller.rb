class VuejsController < ApplicationController
  def index
    render file: "#{Rails.root}/client/index.html"
  end
end

class VuejsController < ApplicationController
  layout false

  def index
    render file: "#{Rails.root}/vue/dist/index.html?t=#{Time.current.to_i}"
  end
end

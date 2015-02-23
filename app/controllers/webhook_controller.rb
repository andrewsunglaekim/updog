class WebhooksController < ApplicationController
  def challenge
    params[:challenge]
  end
  def post
    params
  end
end
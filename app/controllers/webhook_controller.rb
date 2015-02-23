class WebhookController < ApplicationController
  def challenge
    params[:challenge]
  end
  def post
    params
  end
end
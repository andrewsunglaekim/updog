class WebhookController < ApplicationController
  def challenge
    respond_to do |format|
      c =  params[:challenge]
      format.all { render :html => c, :layout => false }
    end
  end
  def post
    p params
  end
end
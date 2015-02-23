class WebhookController < ApplicationController
  protect_from_forgery except: :post
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
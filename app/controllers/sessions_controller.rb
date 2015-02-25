require 'dropbox_sdk'
class SessionsController < ApplicationController
  def get_auth
    redirect_uri = ENV['db_callback']
    flow = DropboxOAuth2Flow.new( ENV['db_key'], ENV['db_secret'], redirect_uri, session, :dropbox_auth_csrf_token)
  end
  def new
     auth_url = get_auth.start
     redirect_to auth_url
  end
  def index
    if session['access_token'] != ''
      @user = get_dropbox_client.account_info['display_name']
    end
  end
  def create     
    code = params[:code]
    begin
      access_token, user_id, url_state = get_auth.finish(params)
    rescue Exception
    end
    session['access_token'] = access_token
    @db = get_client access_token
    name = @db.account_info['display_name']
    email = @db.account_info['email']
    uid = @db.account_info['uid']
    user = User.find_by_provider_and_uid('dropbox', user_id) || User.create_with_omniauth(email, uid, name)     
    session[:user_id] = uid
    session[:access_token] = access_token
    session[:user_name] = name
    user.access_token = access_token
    user.save
    redirect_to '/'
  end
  def destroy
    session.clear
    redirect_to root_url
  end
end
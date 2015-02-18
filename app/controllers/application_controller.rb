require 'dropbox_sdk'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def get_client
    at = session['access_token'] || ENV['access_token']
    return DropboxClient.new(at)
  end

end

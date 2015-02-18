class SitesController < ApplicationController
  def index
    @sites = Site.where( user_id: session[:user_id] )
  end
  def new
    @site = Site.new
  end
  def show
    @site = Site.find_by( user_id: session[:user_id], id: params[:id] )
    @content = get_client.get_file( @site.name+ '/index.html' )
  end
  def load
    @site = Site.find_by(name: request.subdomain)
    @content = get_client.get_file( @site.name + '/index.html' )
  end
  def create
    @site = Site.new site_params.merge( user_id: session[:user_id] )
    @db = get_client
    @db.file_create_folder( @site.name )
    if @site.save
      redirect_to root_url
    end
  end

  private
  def site_params
    params.require(:site).permit(:name)
  end
end

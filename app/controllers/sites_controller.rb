class SitesController < ApplicationController
  protect_from_forgery except: :load
  def index
    @sites = Site.where( user_id: session[:user_id] )
  end
  def new
    @site = Site.new
  end
  def show
    @site = Site.find_by( user_id: session[:user_id], id: params[:id] )
  end
  def load
    @site = Site.find_by(name: request.subdomain)
    @content = @site.content get_client, request.env['PATH_INFO']
    respond_to do |format|
      format.all { render :html => @content, :layout => false }
    end
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

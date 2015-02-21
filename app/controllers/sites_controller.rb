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
  def destroy
    @site = Site.find_by( user_id: session[:user_id], id: params[:id] )
    @site.destroy
    redirect_to sites_path
  end
  def load
    @site = Site.find_by(name: request.subdomain)
    begin
      @content = @site.content get_client, request.env['PATH_INFO']
    rescue Exception => err
      @content = err
    end
    respond_to do |format|
      format.all { render :html => @content, :layout => false }
    end
  end
  def create
    @site = Site.new site_params.merge( user_id: session[:user_id] )
    @site.name.downcase!
    @site.domain = @site.name + '.updog.co'
    @db = get_client
    if @site.save
      begin
      @db.file_create_folder( @site.name )
      @db.put_file('/' + @site.name + '/index.html', open(Rails.public_path + 'welcome.html') )
      rescue
      end
      redirect_to root_url
    else
      render :new
    end
  end

  private
  def site_params
    params.require(:site).permit(:name)
  end
end

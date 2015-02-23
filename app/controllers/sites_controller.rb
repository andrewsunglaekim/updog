class SitesController < ApplicationController
  protect_from_forgery except: :load
  def index
    @sites = Site.where( uid: session[:user_id] )
  end
  def new
    @site = Site.new
  end
  def show
    @site = Site.find_by( uid: session[:user_id], id: params[:id] )
  end
  def destroy
    @site = Site.find_by( uid: session[:user_id], id: params[:id] )
    @site.destroy
    redirect_to sites_path
  end
  def load
    @site = Site.where("domain = ? OR subdomain = ?", request.host, request.host).first
    if !@site
     render :html => 'Not Found', :layout => true
     return
    end
    begin
      @content = @site.content get_client( @site.creator.access_token ), request.env
    rescue Exception => err
      @content = err
    end
    respond_to do |format|
      format.all { render :html => @content, :layout => false }
    end
  end
  def create
    @site = Site.new site_params.merge( uid: session[:user_id] )
    @db = get_client @site.creator.access_token
    if @site.save
      begin
      @db.file_create_folder( @site.name )
      @db.put_file('/' + @site.name + '/index.html', open(Rails.public_path + 'welcome.html') )
      rescue
      end
      redirect_to @site
    else
      render :new
    end
  end

  private
  def site_params
    params.require(:site).permit(:name)
  end
end

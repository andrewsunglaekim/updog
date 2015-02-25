class SitesController < ApplicationController
  protect_from_forgery except: :load
  def index
    @sites = Site.where( uid: session[:user_id] )
  end
  def edit
    @site = Site.find_by( uid: session[:user_id], id: params[:id] )
  end
  def new
    @site = Site.new
  end
  def show
    @site = Site.find_by( uid: session[:user_id], id: params[:id] )
    @sites = current_user && current_user.sites || []
  end
  def destroy
    @site = Site.find_by( uid: session[:user_id], id: params[:id] )
    @site.destroy
    redirect_to sites_path, :notice => "Deleted. #{undo_link}?"
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
  def update
    @site = Site.find_by( uid: session[:user_id], id: params[:id] )
    if @site.update site_params.merge( uid: session[:user_id] )
      redirect_to @site
    else
      render :edit
    end
  end

  private
  def site_params
    params.require(:site).permit(:name, :domain)
  end
  def undo_link
    view_context.link_to("undo", revert_version_path(@site.versions.last), :method => :post)
  end
end

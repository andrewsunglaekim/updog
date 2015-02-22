class PagesController < ApplicationController

  def about
  end

  def pricing
  end

  def source
  end
  
  def admin
    if current_user && current_user.id == 1
      @users = User.all
      @sites = Site.all
    else
      redirect_to root_path
    end
  end
end
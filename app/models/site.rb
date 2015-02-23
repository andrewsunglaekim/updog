class Site < ActiveRecord::Base
  belongs_to :user, :foreign_key => :uid, :primary_key => :uid
  validates :name, uniqueness: { case_sensititve: false }
  validate :user_has_less_than_5_sites
  before_save :namify

  def creator
    User.find_by( uid: self.uid )
  end

  def content client, env 
    if env['REQUEST_URI'][-1] == "/"
      path = env['PATH_INFO'] + "/index.html"
    else
      path = env['PATH_INFO']
    end
    puts path
    Rails.cache.fetch("#{cache_key}/#{path}", expires_in: 30.seconds) do
      begin 
	if path != '/'
	  client.get_file( self.name + '/_site/' + path ).html_safe
	else
	  client.get_file( self.name + '/_site/index.html' ).html_safe
	end
      rescue
	if path != '/'
	  client.get_file( self.name + path ).html_safe
	else
	  client.get_file( self.name + '/index.html' ).html_safe
	end
      end
    end
  end

  def user_has_less_than_5_sites
    if self.user.sites.length > 4 
      errors.add(:number_of_sites, "can't be greater than 5")
    end
  end

  private
   def  namify
    self.name.downcase!
    self.name = self.name.gsub(/[^\w+]/,'-')
    self.name = self.name.gsub(/-+$/,'')
    self.name = self.name.gsub(/^-+/,'')
    self.subdomain = self.name + '.updog.co'
  end

end

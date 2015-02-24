class Site < ActiveRecord::Base
  belongs_to :user, :foreign_key => :uid, :primary_key => :uid
  validates :subdomain, uniqueness: { case_sensititve: false }
  validates :name, presence: true
  validates :domain, uniqueness: { case_sensititve: false, allow_blank: true }
  validate :domain_isnt_updog
  validate :user_has_less_than_5_sites
  before_validation :namify

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
  def domain_isnt_updog
    if self.domain =~ /updog\.co/
      errors.add(:domain, "can't contain updog.co")
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

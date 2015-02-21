class Site < ActiveRecord::Base
  belongs_to :user
  validates :name, uniqueness: { case_sensititve: false }

  def creator
    User.find_by( uid: self.user_id.to_s )
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
end

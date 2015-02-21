class Site < ActiveRecord::Base
  belongs_to :user
  validates :name, uniqueness: { case_sensititve: false }

  def content client, path = ''
    Rails.cache.fetch("#{cache_key}/#{path}", expires_in: 30.seconds) do
      if path != '/'
	puts path
	client.get_file( self.name + path ).html_safe
      else
	client.get_file( self.name + '/index.html' ).html_safe
      end
    end
  end
end

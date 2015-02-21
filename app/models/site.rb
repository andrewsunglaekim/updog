class Site < ActiveRecord::Base
  belongs_to :user
  after_create :create_db_folder

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

  private
  def create_db_folder

  end
end

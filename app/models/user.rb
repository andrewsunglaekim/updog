class User < ActiveRecord::Base
  has_many :sites
  def self.create_with_omniauth( email, uid, name )
	create! do |user|
	  user.email = email
	  user.provider = 'dropbox'
	  user.uid = uid
	  user.name = name
	end
    end
end

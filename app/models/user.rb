class User < ActiveRecord::Base
  has_many :sites, :foreign_key => :uid, :primary_key => :uid
  def self.create_with_omniauth( email, uid, name )
	create! do |user|
	  user.email = email
	  user.provider = 'dropbox'
	  user.uid = uid
	  user.name = name
	end
    end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :dropbox, ENV['db_key'], ENV['db_secret']
end
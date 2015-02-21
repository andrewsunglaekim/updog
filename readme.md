# UpDog

## Local Setup

    $ git clone git@github.com:jshawl/updog.git
    $ cd updog
    $ bundle install
    $ rake db:create
    $ rake db:migrate

Create a new file:

```ruby
# updog/config/application.yml

db_key: 'dropbox consumer key'
db_secret: 'dropbox consumer secret'
db_callback: 'http://localhost:3000/auth/dropbox/callback'
```

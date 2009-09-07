# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_fandouai_session',
  :secret      => 'a365a865a8b3bef172579d191419ca37d7d8dbd3432133882c1188b1ec8a931b125efd70517bb12ef5d16551b22382342dea75de42905ac51fc0b47aee3c34f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

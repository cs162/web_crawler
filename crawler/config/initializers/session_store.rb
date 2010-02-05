# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_crawler_session',
  :secret      => 'bc28c607117c397d8ff4e1be04aa3fce0b4288ad79c9bbaf585bd13a933d2f99d6aab325a471d6f80824cc475ae2535c0b09b8999988c212b1b93c14d02a8f31'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

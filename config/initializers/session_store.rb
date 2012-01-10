# Be sure to restart your server when you modify this file.

# Kogo::Application.config.session_store :cookie_store, key: '_kogo_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
Kogo::Application.config.session_store :active_record_store
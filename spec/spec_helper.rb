# frozen_string_literal: true

require 'simplecov'

SimpleCov.start

require 'restiny'
require 'vcr'

Restiny.api_key = ENV.fetch('DESTINY_API_KEY')
Restiny.oauth_client_id = ENV.fetch('DESTINY_OAUTH_CLIENT_ID')

VCR.configure do |c|
  c.cassette_library_dir = File.join(__dir__, 'cassettes')
  c.default_cassette_options = { serialize_with: :json, record: :new_episodes }

  c.define_cassette_placeholder('<API_KEY>') { ENV.fetch('DESTINY_API_KEY') }
  c.define_cassette_placeholder('<OAUTH_CLIENT_ID>') { ENV.fetch('DESTINY_OAUTH_CLIENT_ID') }

  c.hook_into :faraday

  c.before_record { |interaction| interaction.response.headers.delete('set-cookie') }

  c.configure_rspec_metadata!
end

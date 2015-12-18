$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'zengin_bank_gem'

RSpec.configure do |config|
  config.filter_run_excluding full_dump: true
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.allow_http_connections_when_no_cassette = true
end

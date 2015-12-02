$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'zengin_bank_gem'

VCR.configure do |c|
  c.cassette_library_dir = 'cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end
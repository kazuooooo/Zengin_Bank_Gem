# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zengin_bank_gem/version'

Gem::Specification.new do |spec|
  spec.name          = "zengin_bank_gem"
  spec.version       = ZenginBankGem::VERSION
  spec.authors       = ["kazuya.matsumoto"]
  spec.email         = ["matsumotokazuya7@gmail.com"]

  spec.summary       = %q{zengin bank gem}
  spec.description   = %q{gem for using bank and branches info scraped from Zengin System(http://zengin.ajtw.net/)}
  spec.homepage      = "https://github.com/kazuooooo/Zengin_Bank_Gem"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "mechanize"
  spec.add_dependency "nokogiri"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "fuubar"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'loquor/version'

Gem::Specification.new do |spec|
  spec.name          = "loquor"
  spec.version       = Loquor::VERSION
  spec.authors       = ["Jeremy Walker"]
  spec.email         = ["jez.walker@gmail.com"]
  spec.description   = "An API dispatcher for Meducation"
  spec.summary       = "This library dispatches requests to Meducation"
  spec.homepage      = "https://www.meducation.net"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'filum', '~> 1.0'
  spec.add_dependency 'rest-client', '1.6.7'
  spec.add_dependency "api-auth", "1.0.3"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "minitest", '~> 5.0.8'
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "rake"
end

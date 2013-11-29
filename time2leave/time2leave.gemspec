# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'time2leave/version'

Gem::Specification.new do |spec|
  spec.name          = "time2leave"
  spec.version       = Time2leave::VERSION
  spec.authors       = ["JAdshead"]
  spec.email         = ["jonny.adshead@gmail.com"]
  spec.description   = %q{takes flight number, your airport hang time, and start location. Will return time of departure (local and UTC) as well as other flight information}
  spec.summary       = %q{How Long Have I Got?}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
    spec.add_dependency "mechanize"
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'polar_express/version'

Gem::Specification.new do |spec|
  spec.name          = "polar_express"
  spec.version       = PolarExpress::VERSION
  spec.authors       = ["José Tomás Albornoz"]
  spec.email         = ["jojo@eljojo.net"]
  spec.description   = %q{Package tracking done right.}
  spec.summary       = %q{An easy an fun way of tracking packages. info = PolarExpress.new('DHL', '123456789').track!}
  spec.homepage      = "https://github.com/eljojo/polar_express"
  spec.license       = "mit"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3.0"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "shoulda"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rb-fsevent"
end

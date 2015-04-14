# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'transmuxer/version'

Gem::Specification.new do |spec|
  spec.name          = "transmuxer"
  spec.version       = Transmuxer::VERSION
  spec.authors       = ["Ali B. Aslam"]
  spec.email         = ["ali@bletchley.co"]
  spec.homepage      = "http://github.com/bletchley/transmuxer"

  spec.summary       = %q{A library for converting videos into HLS format.}

  spec.license       = "MIT"

  spec.files         = Dir["config/**/*", "lib/**/*.rb", "app/**/*", "LICENSE.txt", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "zencoder", "~> 2.5.1"
  spec.add_dependency "activerecord", ">= 3.2", "< 5"
  spec.add_dependency "railties", ">= 3.2", "< 5"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
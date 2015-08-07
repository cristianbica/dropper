# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'droppper/version'

Gem::Specification.new do |spec|
  spec.name          = "droppper"
  spec.version       = Droppper::VERSION
  spec.authors       = ["Cristian Bica"]
  spec.email         = ["cristian.bica@gmail.com"]

  spec.summary       = %q{DigitalOcean CLI.}
  spec.description   = %q{DigitalOcean CLI using DigitalOcean's API v2.}
  spec.homepage      = "https://github.com/cristianbica/droppper"


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "gli", ">= 2.0"
  spec.add_dependency "highline"
  spec.add_dependency "table_print"
  spec.add_dependency "droplet_kit"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end

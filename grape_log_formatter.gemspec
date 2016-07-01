# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "grape_log_formatter/version"

Gem::Specification.new do |spec|
  spec.name          = "grape_log_formatter"
  spec.version       = GrapeLogFormatter::VERSION
  spec.authors       = ["Robin Bortlik"]
  spec.email         = ["robinbortlik@gmail.com"]

  spec.summary       = "Reevoo log formatter for grape API"
  spec.description   = "Log formatter which improve the readability of the log and add additional informations"
  spec.homepage      = "https://github.com/reevoo/grape_log_formatter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'patme/version'

Gem::Specification.new do |spec|
  spec.name          = "patme"
  spec.version       = Patme::VERSION
  spec.authors       = ["Dmitrii Krasnov"]
  spec.email         = ["vizvamitra@gmail.com"]

  spec.summary       = "Pattern matching for ruby methods"
  spec.description   = "Elixir-style pattern matching for ruby methods"
  spec.homepage      = "http://github.com/vizvamitra/patme"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'parser', "~> 2.4"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end

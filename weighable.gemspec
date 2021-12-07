# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'weighable/version'

Gem::Specification.new do |spec|
  spec.name          = 'weighable'
  spec.version       = Weighable::VERSION
  spec.authors       = ['Trae Robrock']
  spec.email         = ['trobrock@gmail.com']

  spec.summary       = 'Like BigDecimal, but for weight. Includes Rails integration.'
  spec.description   = 'Like BigDecimal, but for weight. Includes Rails integration.'
  spec.homepage      = 'https://github.com/greenbits/weighable'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
    .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '> 4.2.4'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rails', '~> 5.0.7.2'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.49.0'
  spec.add_development_dependency 'rspec', '~> 3.4.0'
  spec.add_development_dependency 'guard', '~> 2.13.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.6.4'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'simplecov'
end

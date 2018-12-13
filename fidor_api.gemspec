lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fidor_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'fidor_api'
  spec.version       = FidorApi::VERSION
  spec.authors       = ['Fidor Solutions AG']
  spec.email         = ['connect@fidor.com']
  spec.summary       = 'Ruby client library to work with Fidor APIs'
  spec.homepage      = 'https://github.com/fidor/fidor_api'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*', 'Rakefile', 'README.md']
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activemodel', '~> 5.0'
  spec.add_dependency 'faraday', '~> 0.15'
  spec.add_dependency 'faraday_middleware', '~> 0.12'
  spec.add_dependency 'model_attribute', '~> 3.2'

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'byebug', '~> 10.0'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '= 0.61.1'
  spec.add_development_dependency 'simplecov', '~> 0.10'
  spec.add_development_dependency 'webmock', '~> 3.4'
end

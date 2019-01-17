lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'warnings/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name = 'danger-warnings'
  spec.version = Warnings::VERSION
  spec.authors = ['Kyaak']
  spec.email = ['kyaak.dev@gmail.com']
  spec.description = 'Report lint warnings'
  spec.summary = 'Report lint warnings of different tools.'
  spec.homepage = 'https://github.com/Kyaak/danger-warnings'
  spec.license = 'MIT'

  spec.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>=2.2.0'

  spec.add_runtime_dependency 'abstract_method', '~> 1.2'
  spec.add_runtime_dependency 'danger-plugin-api', '~> 1.0'

  # General ruby development
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 10.0'

  # Testing support
  spec.add_development_dependency 'mocha', '~> 1.2'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'simplecov', '~> 0.16'
  spec.add_development_dependency 'simplecov-console', '~> 0.4'

  # Linting code and docs
  spec.add_development_dependency 'rubocop', '~> 0.60'
  spec.add_development_dependency 'yard', '~> 0.9'

  # Makes testing easy via `bundle exec guard`
  spec.add_development_dependency 'guard', '~> 2.14'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'

  # If you want to work on older builds of ruby
  spec.add_development_dependency 'listen', '3.0.7'

  # This gives you the chance to run a REPL inside your tests
  # via:
  #
  #    require 'pry'
  #    binding.pry
  #
  # This will stop test execution and let you inspect the results
  spec.add_development_dependency 'pry'
end

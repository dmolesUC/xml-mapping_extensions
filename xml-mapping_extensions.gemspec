# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'uri'
require 'xml/mapping_extensions/version'

Gem::Specification.new do |spec|
  spec.name = 'xml-mapping_extensions'
  spec.version = XML::MappingExtensions::VERSION
  spec.authors = ['David Moles']
  spec.email = ['david.moles@ucop.edu']
  spec.summary = 'Some extensions for for XML::Mapping'
  spec.description = 'Mapping nodes and other utility classes extending XML::Mapping'
  spec.license = 'MIT'

  origin = `git config --get remote.origin.url`.chomp
  origin_uri = origin.start_with?('http') ? URI(origin) : URI(origin.sub('git@github.com:', 'https://github.com/'))
  spec.homepage = URI::HTTP.build(host: origin_uri.host, path: origin_uri.path.chomp('.git')).to_s

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'mime-types', '~> 2.5'
  spec.add_dependency 'typesafe_enum', '~> 0.1', '>= 0.1.5'
  spec.add_dependency 'xml-mapping', '~> 0.10'

  spec.add_development_dependency 'activesupport', '~> 4.2' # for testing
  spec.add_development_dependency 'equivalent-xml', '~> 0.6.0'
  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'rubocop', '~> 0.32.1'
  spec.add_development_dependency 'simplecov', '~> 0.9.2'
  spec.add_development_dependency 'simplecov-console', '~> 0.2.0'
  spec.add_development_dependency 'yard', '~> 0.8'
end

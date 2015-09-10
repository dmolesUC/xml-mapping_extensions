# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'xml/mapping_extensions'

Gem::Specification.new do |spec|
  spec.name = 'xml-mapping_extensions'
  spec.version = XML::MappingExtensions::VERSION
  spec.authors = ['David Moles']
  spec.email = ['david.moles@ucop.edu']
  spec.summary = 'Some extensions for for XML::Mapping'
  spec.description = 'Mapping nodes and other utility classes extending XML::Mapping'
  spec.license = 'MIT'

  origin_uri = URI(`git config --get remote.origin.url`.chomp)
  spec.homepage = URI::HTTP.build(host: origin_uri.host, path: origin_uri.path.chomp('.git')).to_s

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'xml-mapping', '~> 0.10'
end

require 'spec_helper'

module XML
  module MappingExtensions
    describe Namespace do
      describe '#set_default_namespace' do
        it 'sets the default namespace'
        it 'sets the schema location'
        it 'allows a nil schema location'
        it 'sets the no-namespace schema location'
        it 'allows a nil no-namespace schema location'
      end

      describe '#set_prefix' do
        it 'sets the prefix'
        it 'clears the no-prefix namespace, if previously present'
        it 'leaves an unrelated no-prefix namespace intact'
      end

      describe '#to_s' do
        it 'includes the prefix, namespace, and schema location' do
          uri             = 'http://example.org/px/'
          prefix          = 'px'
          schema_location = 'http://example.org/px.xsd'
          namespace = MappingExtensions::Namespace.new(uri: uri, prefix: prefix, schema_location: schema_location)
          expect(namespace.to_s).to match(/Namespace.*#{uri}.*#{prefix}.*#{schema_location}/)
        end

        it 'accepts a nil prefix' do
          uri             = 'http://example.org/px/'
          schema_location = 'http://example.org/px.xsd'
          namespace = MappingExtensions::Namespace.new(uri: uri, schema_location: schema_location)
          expect(namespace.to_s).to match(/Namespace.*#{uri}.*nil.*#{schema_location}/)
        end

        it 'accepts a nil schema_location' do
          uri             = 'http://example.org/px/'
          prefix          = 'px'
          namespace = MappingExtensions::Namespace.new(uri: uri, prefix: prefix)
          expect(namespace.to_s).to match(/Namespace.*#{uri}.*#{prefix}.*nil/)
        end
      end
    end
  end
end

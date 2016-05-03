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
          namespace       = Namespace.new(uri: uri, prefix: prefix, schema_location: schema_location)
          expect(namespace.to_s).to match(/Namespace.*#{uri}.*#{prefix}.*#{schema_location}/)
        end

        it 'accepts a nil prefix' do
          uri             = 'http://example.org/px/'
          schema_location = 'http://example.org/px.xsd'
          namespace       = Namespace.new(uri: uri, schema_location: schema_location)
          expect(namespace.to_s).to match(/Namespace.*#{uri}.*nil.*#{schema_location}/)
        end

        it 'accepts a nil schema_location' do
          uri       = 'http://example.org/px/'
          prefix    = 'px'
          namespace = Namespace.new(uri: uri, prefix: prefix)
          expect(namespace.to_s).to match(/Namespace.*#{uri}.*#{prefix}.*nil/)
        end
      end

      describe 'equality' do
        describe 'equal objects' do
          before(:each) do
            @ns1 = Namespace.new(uri: 'http://example.org/px/', prefix: 'px', schema_location: 'http://example.org/px.xsd')
            @ns2 = Namespace.new(uri: 'http://example.org/px/', prefix: 'px', schema_location: 'http://example.org/px.xsd')
          end

          it 'are equal' do
            expect(@ns1).to eq(@ns2)
            expect(@ns2).to eq(@ns1)
          end

          it 'have the same hash code' do
            expect(@ns1.hash).to eq(@ns2.hash)
            expect(@ns2.hash).to eq(@ns1.hash)
          end
        end

        describe 'unequal objects' do
          before(:each) do
            @nss = [
              Namespace.new(uri: 'http://example.org/px/', prefix: 'px', schema_location: 'http://example.org/px.xsd'),
              Namespace.new(uri: 'http://example.com/px/', prefix: 'px', schema_location: 'http://example.org/px.xsd'),
              Namespace.new(uri: 'http://example.org/px/', prefix: 'px', schema_location: 'http://example.com/px.xsd'),
              Namespace.new(uri: 'http://example.org/px/', prefix: 'px2', schema_location: 'http://example.org/px.xsd'),
              Namespace.new(uri: 'http://example.org/px/', schema_location: 'http://example.org/px.xsd'),
              Namespace.new(uri: 'http://example.org/px/', prefix: 'px')
            ]
          end

          it 'are unequal' do
            @nss.each do |ns1|
              @nss.each do |ns2|
                next if ns1.equal?(ns2)
                expect(ns1).not_to eq(ns2)
              end
            end
          end

          it 'have different hash codes' do
            @nss.each do |ns1|
              @nss.each do |ns2|
                next if ns1.equal?(ns2)
                expect(ns1.hash).not_to eq(ns2.hash)
              end
            end
          end
        end
      end
    end
  end
end

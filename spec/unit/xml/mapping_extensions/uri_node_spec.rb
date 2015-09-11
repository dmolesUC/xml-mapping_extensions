require 'spec_helper'

module XML
  module MappingExtensions

    class UriNodeSpecElem
      include XML::Mapping
      uri_node :uri, '@uri', default_value: nil

      def self.from_str(uri_str)
        xml_string = uri_str ? "<elem uri='#{uri_str}'/>" : '<elem/>'
        doc = REXML::Document.new(xml_string)
        load_from_xml(doc.root)
      end
    end

    describe UriNode do

      def to_uri(str)
        UriNodeSpecElem.from_str(str).uri
      end

      def to_text(uri)
        elem = UriNodeSpecElem.new
        elem.uri = uri
        xml = elem.save_to_xml
        xml.attributes['uri']
      end

      it 'parses a URI' do
        uri_str = 'http://example.org/'
        expect(to_uri(uri_str)).to eq(URI(uri_str))
      end

      it 'strips whitespace' do
        uri_str = 'http://example.org/'
        expect(to_uri(" #{uri_str} ")).to eq(URI(uri_str))
      end

      it 'fails on a malformed URI' do
        bad_uri = 'I am not a URI'
        expect { to_uri(" #{bad_uri} ") }.to raise_error(URI::InvalidURIError)
      end

      it 'transforms a URI to a string' do
        uri_str = 'http://example.org/'
        expect(to_text(URI(uri_str))).to eq(uri_str)
      end

      it 'doesn\'t set an attribute for a nil value' do
        expect(to_text(nil)).to be_nil
      end

    end

  end
end

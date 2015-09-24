require 'spec_helper'

module XML
  module MappingExtensions

    class MimeTypeSpecElem
      include XML::Mapping
      mime_type_node :mime_type, '@mime_type', default_value: nil

      def self.from_str(mt_string)
        xml_string = mt_string ? "<elem mime_type='#{mt_string}'/>" : '<elem/>'
        doc = REXML::Document.new(xml_string)
        load_from_xml(doc.root)
      end
    end

    describe MimeTypeNode do
      def to_mime_type(str)
        MimeTypeSpecElem.from_str(str).mime_type
      end

      def to_text(mime_type)
        elem = MimeTypeSpecElem.new
        elem.mime_type = mime_type
        xml = elem.save_to_xml
        xml.attributes['mime_type']
      end

      it 'converts a string value to a MIME type' do
        mt_string = 'application/x-whatever'
        mt = MIME::Type.new(mt_string)

        elem = MimeTypeSpecElem.new
        elem.mime_type = mt_string
        expect(elem.mime_type).to eq(mt)
      end

      it 'accepts a standard MIME type' do
        mt_str = 'text/plain'
        mt = MIME::Types[mt_str].first
        expect(to_mime_type(mt_str)).to eq(mt)
      end

      it 'accepts a non-standard MIME type' do
        mt_str = 'elvis/presley'
        mt = MIME::Type.new(mt_str)
        expect(to_mime_type(mt_str)).to eq(mt)
      end

      it 'doesn\'t set an attribute for a nil value' do
        expect(to_text(nil)).to be_nil
      end

      it 'fails if mime_type isn\'t a MIME type' do
        mt_str = 'I am not a mime type'
        expect { to_mime_type(mt_str) }.to raise_error(MIME::Type::InvalidContentType)
      end

    end
  end
end

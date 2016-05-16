require 'spec_helper'
require 'tempfile'

module XML
  module Mapping
    class MXSpecObject
      include ::XML::Mapping
      include Comparable

      root_element_name 'element'

      numeric_node :attribute, '@attribute'
      text_node :text, 'text()'
      array_node :children, 'child', class: String

      def <=>(other)
        return nil unless self.class == other.class
        [:attribute, :text, :children].each do |p|
          order = send(p) <=> other.send(p)
          return order if order != 0
        end
        0
      end

      def hash
        [:attribute, :text, :children].hash
      end
    end

    describe '#write_xml' do
      it 'writes an XML string' do
        obj = MXSpecObject.new
        obj.attribute = 123
        obj.text = 'element text'
        obj.children = ['child 1', 'child 2']
        expected_xml = obj.save_to_xml
        xml_string = obj.write_xml
        expect(xml_string).to be_a(String)
        expect(xml_string).to be_xml(expected_xml)
      end
    end

    describe ':namespace' do
      it 'sets the namespace on save' do
        uri = 'http://example.org/px/'
        schema_location = 'http://example.org/px.xsd'

        MXSpecObject.send(:include, MappingExtensions::Namespaced)
        MXSpecObject.namespace(MappingExtensions::Namespace.new(uri: uri, prefix: 'px', schema_location: schema_location))

        obj = MXSpecObject.new
        obj.attribute = 123
        obj.text = 'element text'
        obj.children = ['child 1', 'child 2']

        namespace_attribs = "xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:schemaLocation='#{schema_location}' xmlns:px='#{uri}'"
        expected = "<px:element #{namespace_attribs} attribute='123'>element text<px:child>child 1</px:child><px:child>child 2</px:child></px:element>"

        expect(obj.save_to_xml).to be_xml(expected)
      end

      it 'works without prefixes' do
        uri = 'http://example.org/px/'
        schema_location = 'http://example.org/px.xsd'

        MXSpecObject.send(:include, MappingExtensions::Namespaced)
        MXSpecObject.namespace(MappingExtensions::Namespace.new(uri: uri, schema_location: schema_location))

        obj = MXSpecObject.new
        obj.attribute = 123
        obj.text = 'element text'
        obj.children = ['child 1', 'child 2']

        namespace_attribs = "xmlns='#{uri}' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:schemaLocation='#{schema_location}'"
        expected = "<element #{namespace_attribs} attribute='123'>element text<child>child 1</child><child>child 2</child></element>"

        expect(obj.save_to_xml).to be_xml(expected)
      end
    end

    module ClassMethods
      describe '#parse_xml' do

        before(:each) do
          @xml_string = '<element attribute="123">
                           element text
                           <child>child 1</child>
                           <child>child 2</child>
                         </element>'
          @xml_document = REXML::Document.new(@xml_string)
          @xml_element = @xml_document.root
          @expected_element = MXSpecObject.load_from_xml(@xml_element)
        end

        it 'parses a String' do
          obj = MXSpecObject.parse_xml(@xml_string)
          expect(obj).to eq(@expected_element)
        end

        it 'parses a REXML::Document' do
          obj = MXSpecObject.parse_xml(@xml_document)
          expect(obj).to eq(@expected_element)
        end

        it 'parses a REXML::Element' do
          obj = MXSpecObject.parse_xml(@xml_element)
          expect(obj).to eq(@expected_element)
        end

        it 'parses an IO' do
          xml_io = StringIO.new(@xml_string)
          obj = MXSpecObject.parse_xml(xml_io)
          expect(obj).to eq(@expected_element)
        end

        it 'parses a file' do
          xml_file = Tempfile.new(%w(parse_xml_spec .xml))
          begin
            xml_file.write(@xml_string)
            xml_file.rewind
            obj = MXSpecObject.parse_xml(xml_file)
            expect(obj).to eq(@expected_element)
          ensure
            xml_file.close(true)
          end
        end
      end
    end
  end
end

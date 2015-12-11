require 'spec_helper'
require 'tempfile'

module XML
  module Mapping
    module ClassMethods
      class ParseXMLSpecElement
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

      describe '#parse_xml' do

        before(:each) do
          @xml_string = '<element attribute="123">
                           element text
                           <child>child 1</child>
                           <child>child 2</child>
                         </element>'
          @xml_document = REXML::Document.new(@xml_string)
          @xml_element = @xml_document.root
          @expected_element = ParseXMLSpecElement.load_from_xml(@xml_element)
        end

        it 'parses a String' do
          elem = ParseXMLSpecElement.parse_xml(@xml_string)
          expect(elem).to eq(@expected_element)
        end

        it 'parses a REXML::Document' do
          elem = ParseXMLSpecElement.parse_xml(@xml_document)
          expect(elem).to eq(@expected_element)
        end

        it 'parses a REXML::Element' do
          elem = ParseXMLSpecElement.parse_xml(@xml_element)
          expect(elem).to eq(@expected_element)
        end

        it 'parses an IO' do
          xml_io = StringIO.new(@xml_string)
          elem = ParseXMLSpecElement.parse_xml(xml_io)
          expect(elem).to eq(@expected_element)
        end

        it 'parses a file' do
          xml_file = Tempfile.new(%w(parse_xml_spec .xml))
          begin
            xml_file.write(@xml_string)
            xml_file.rewind
            elem = ParseXMLSpecElement.parse_xml(xml_file)
            expect(elem).to eq(@expected_element)
          ensure
            xml_file.close(true)
          end
        end
      end
    end
  end
end

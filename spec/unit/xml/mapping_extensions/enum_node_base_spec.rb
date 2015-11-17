require 'spec_helper'

module XML
  module MappingExtensions

    class MyEnum
      include Ruby::Enum

      define :FOO, 'foo'
      define :BAR, 'bar'
      define :BAZ_QUX, 'baz_qux'
    end

    class MyEnumNode < EnumNodeBase
      ENUM_CLASS = MyEnum
    end
    ::XML::Mapping.add_node_class(MyEnumNode)

    class EnumNodeBaseSpecElem
      include ::XML::Mapping
      my_enum_node :my_enum, '@my_enum', default_value: nil

      root_element_name 'elem'

      def self.from_str(enum_str)
        xml_string = enum_str ? "<elem my_enum='#{enum_str}'/>" : '<elem/>'
        doc = REXML::Document.new(xml_string)
        load_from_xml(doc.root)
      end
    end
    describe EnumNodeBase do

      def to_my_enum(str)
        EnumNodeBaseSpecElem.from_str(str).my_enum
      end

      def to_text(enum)
        elem = EnumNodeBaseSpecElem.new
        elem.my_enum = enum
        xml = elem.save_to_xml
        xml.attributes['my_enum']
      end

      it 'parses an enum value' do
        MyEnum.map do |_, enum|
          expect(to_my_enum(enum.value)).to eq(enum)
        end
      end

      it 'transforms an enum to a string' do
        MyEnum.map do |_, enum|
          expect(to_text(enum)).to eq(enum.value)
        end
      end

      it 'parses a missing value as nil' do
        expect(to_my_enum(nil)).to be_nil
      end

      it 'doesn\'t set an attribute for a nil value' do
        expect(to_text(nil)).to be_nil
      end

      it 'accepts enum constants' do
        elem = EnumNodeBaseSpecElem.new
        elem.my_enum = MyEnum::BAZ_QUX
        xml_string = '<elem my_enum="baz_qux"/>'
        expect(elem.save_to_xml).to be_xml(xml_string)
      end

      it 'round-trips to XML' do
        xml_string = '<elem my_enum="baz_qux"/>'
        doc = REXML::Document.new(xml_string)
        elem = EnumNodeBaseSpecElem.load_from_xml(doc.root)
        expect(elem.save_to_xml).to be_xml(xml_string)
      end
    end
  end
end

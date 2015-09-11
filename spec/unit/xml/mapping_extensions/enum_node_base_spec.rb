require 'spec_helper'

module XML
  module MappingExtensions

    class MyEnum
      include Ruby::Enum

      define :FOO, 'foo'
      define :BAR, 'bar'
    end

    class MyEnumNode < EnumNodeBase
      ENUM_CLASS = MyEnum
    end
    ::XML::Mapping.add_node_class(MyEnumNode)

    class EnumNodeBaseSpecElem
      include ::XML::Mapping
      my_enum_node :my_enum, '@my_enum', default_value: nil

      def self.from_str(enum_str)
        enum_str ? xml_string = "<elem my_enum='#{enum_str}'/>" : xml_string = '<elem/>'
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
        expect(to_my_enum('foo')).to eq(MyEnum::FOO)
      end

      it 'transforms an enum to a string' do
        expect(to_text(MyEnum::BAR)).to eq('bar')
      end

      it 'parses a missing value as nil' do
        expect(to_my_enum(nil)).to be_nil
      end

      it 'doesn\'t set an attribute for a nil value' do
        expect(to_text(nil)).to be_nil
      end
    end
  end
end

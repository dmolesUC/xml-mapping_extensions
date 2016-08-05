require 'spec_helper'

module XML
  module MappingExtensions

    class MyStringEnum < TypesafeEnum::Base
      [:FOO, :BAR, :BAZ_QUX].each { |k| new k }
    end

    class MySymbolEnum < TypesafeEnum::Base
      new :FOO, :foo
      new :BAR, :bar
      new :BAZ_QUX, :baz_qux
    end

    class TypesafeEnumNodeSpecElem
      include ::XML::Mapping
      typesafe_enum_node :my_string_enum, '@my_string_enum', default_value: nil, class: MyStringEnum
      typesafe_enum_node :my_symbol_enum, '@my_symbol_enum', default_value: nil, class: MySymbolEnum

      root_element_name 'elem'
    end

    describe TypesafeEnumNode do

      def to_my_string_enum(enum_str)
        xml_string = enum_str ? "<elem my_string_enum='#{enum_str}'/>" : '<elem/>'
        doc = REXML::Document.new(xml_string)
        TypesafeEnumNodeSpecElem.load_from_xml(doc.root).my_string_enum
      end

      def to_my_symbol_enum(enum_str)
        xml_string = enum_str ? "<elem my_symbol_enum='#{enum_str}'/>" : '<elem/>'
        doc = REXML::Document.new(xml_string)
        TypesafeEnumNodeSpecElem.load_from_xml(doc.root).my_symbol_enum
      end

      def string_enum_to_text(enum)
        elem = TypesafeEnumNodeSpecElem.new
        elem.my_string_enum = enum
        xml = elem.save_to_xml
        xml.attributes['my_string_enum']
      end

      def symbol_enum_to_text(enum)
        elem = TypesafeEnumNodeSpecElem.new
        elem.my_symbol_enum = enum
        xml = elem.save_to_xml
        xml.attributes['my_symbol_enum']
      end

      it 'works with a string enum' do
        MyStringEnum.each do |enum|
          expect(to_my_string_enum(enum.value)).to eq(enum)
        end

        MyStringEnum.each do |enum|
          expect(string_enum_to_text(enum)).to eq(enum.value)
        end
      end

      it 'works with a symbol enum' do
        MySymbolEnum.each do |enum|
          expect(to_my_symbol_enum(enum.value)).to eq(enum)
        end

        MySymbolEnum.each do |enum|
          expect(symbol_enum_to_text(enum)).to eq(enum.value.to_s)
        end
      end

      it 'parses a nil value as nil' do
        expect(to_my_string_enum(nil)).to be_nil
      end

      it 'raises ArgumentError for an invalid value' do
        expect { to_my_string_enum('elvis') }.to raise_error(ArgumentError)
      end

      it 'doesn\'t set an attribute for a nil value' do
        expect(string_enum_to_text(nil)).to be_nil
      end

      it 'accepts enum constants' do
        elem = TypesafeEnumNodeSpecElem.new
        elem.my_string_enum = MyStringEnum::BAZ_QUX
        xml_string = '<elem my_string_enum="baz_qux"/>'
        expect(elem.save_to_xml).to be_xml(xml_string)
      end

      it 'round-trips to XML' do
        xml_string = '<elem my_string_enum="baz_qux"/>'
        doc = REXML::Document.new(xml_string)
        elem = TypesafeEnumNodeSpecElem.load_from_xml(doc.root)
        expect(elem.save_to_xml).to be_xml(xml_string)
      end

      it 'requires a class' do
        expect do
          class TypesafeEnumNodeSpecElem
            include ::XML::Mapping

            typesafe_enum_node :my_bad_enum, '@my_bad_enum'
          end
        end.to raise_error(ArgumentError)
      end
    end
  end
end

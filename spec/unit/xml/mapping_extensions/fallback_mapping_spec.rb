require 'spec_helper'

module XML
  module Mapping
    class FMSpecObject
      include ::XML::MappingExtensions

      root_element_name 'element'

      numeric_node :attribute, '@attribute'
      text_node :text, 'text()'
      array_node :children, 'child', class: String
      numeric_node :stepchild, 'stepchild'

      use_mapping :alternate
      text_node :attribute, '@attribute'
      array_node :children, 'children',
                 reader: (proc do |obj, xml|
                   children_elem = xml.elements['children']
                   obj.children = children_elem ? children_elem.text.split(',') : []
                 end),
                 writer: (proc do |obj, xml|
                   children_text = obj.children.join(',') if obj.children && !obj.children.empty?
                   xml.add_element('children').text = children_text if children_text
                 end)
      text_node :stepchild, 'stepchild'

      fallback_mapping :alternate, :_default
    end

    describe '#save_to_xml' do
      it 'writes an XML string' do
        obj = FMSpecObject.new
        obj.attribute = 123
        obj.text = 'element text'
        obj.children = ['child 1', 'child 2']
        obj.stepchild = 456
        saved_xml = obj.save_to_xml
        expected_xml = '<element attribute="123">element text<child>child 1</child><child>child 2</child><stepchild>456</stepchild></element>'
        expect(saved_xml).to be_xml(expected_xml)
      end

      it 'accepts an alternate mapping' do
        obj = FMSpecObject.new
        obj.attribute = 'elvis'
        obj.text = 'element text'
        obj.children = ['child 1', 'child 2']
        obj.stepchild = 456
        saved_xml = obj.save_to_xml(mapping: :alternate)
        expected_xml = '<element attribute="elvis">element text<children>child 1,child 2</children><stepchild>456</stepchild></element>'
        expect(saved_xml).to be_xml(expected_xml)
      end
    end

    describe '#parse_xml' do
      it 'parses a String' do
        xml_string = '<element attribute="123">element text<child>child 1</child><child>child 2</child><stepchild>456</stepchild></element>'
        obj = FMSpecObject.parse_xml(xml_string)
        expect(obj.attribute).to eq(123)
        expect(obj.text).to eq('element text')
        expect(obj.children).to eq(['child 1', 'child 2'])
        expect(obj.stepchild).to eq(456)
      end

      it 'accepts an alternate mapping' do
        xml_string = '<element attribute="elvis">element text<children>child 1,child 2</children><stepchild>456</stepchild></element>'
        obj = FMSpecObject.parse_xml(xml_string, mapping: :alternate)
        expect(obj.attribute).to eq('elvis')
        expect(obj.text).to eq('element text')
        expect(obj.children).to eq(['child 1', 'child 2'])
        expect(obj.stepchild).to eq('456')
      end
    end

    class ValidatingElement
      include ::XML::Mapping

      root_element_name 'element'
      text_node :name, '@name'
      text_node :value, '@value'

      use_mapping :strict
      numeric_node :value, '@value', writer: proc { |obj, xml| xml.add_attribute('value', Float(obj.value)) }

      fallback_mapping :strict, :_default
    end

    describe '#fallback_mapping' do
      it 'round-trips' do
        invalid_string = '<element name="abc" value="efg"/>'
        expect { ValidatingElement.parse_xml(invalid_string, mapping: :strict) }.to raise_error(ArgumentError)

        elem = ValidatingElement.parse_xml(invalid_string) # OK
        expect(elem.write_xml).to be_xml("<element name='abc' value='efg'/>")

        expect { elem.write_xml(mapping: :strict) }.to raise_error(ArgumentError)

        elem.value = 123.4
        expect(elem.write_xml(mapping: :strict)).to be_xml("<element value='123.4' name='abc'/>")
      end
    end
  end
end

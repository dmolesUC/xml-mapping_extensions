require 'spec_helper'

module XML
  module Mapping
    class Value
      attr_reader :value

      def initialize(value:)
        @value = value
      end
    end

    class ValueNode < SingleAttributeNode
      def initialize(*args)
        path, *args = super(*args)
        @path = ::XML::XXPath.new(path)
        args
      end

      def set_attr_value(xml, value)
        element = @path.first(xml, ensure_created: true)
        if mapping == :fancy
          element.attributes << REXML::Attribute.new('value', value)
        else
          element.text = value
        end
      end
    end
    XML::Mapping.add_node_class ValueNode

    class Holder
      include XML::Mapping

      def initialize(value)
        @value = value
      end

      value_node :value, 'value', default_value: nil
      use_mapping :fancy
      fallback_mapping :fancy, :_default
    end

    class HolderHolder
      include XML::Mapping
      array_node :holders, 'holders', 'holder', class: Holder, default_value: []
      use_mapping :fancy
      fallback_mapping :fancy, :_default
    end

    describe '#fallback_mapping' do
      it 'works with arrays mapped by custom nodes' do
        expected = '<holder-holder>
          <holders>
            <holder value="foo">
            <holder value="bar">
          </holders>
        </holder-holder>'

        hh = HolderHolder.new
        hh.holders = [Holder.new('foo'), Holder.new('bar')]
        xml = hh.write_xml({mapping: :fancy})
        expect(xml).to be_xml(expected)
      end
    end

  end
end

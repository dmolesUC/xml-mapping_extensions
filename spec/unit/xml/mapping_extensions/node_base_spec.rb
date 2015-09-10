require 'spec_helper'

module XML
  module MappingExtensions

    class SomeMappingClass
      include ::XML::Mapping
    end

    describe NodeBase do
      before :each do
        @node = NodeBase.new(SomeMappingClass, :attr_name, 'attr_name')
      end

      describe '#extract_attr_value' do
        it 'forwards to #to_value'
      end

      describe '#set_attr_value' do
        it 'forwards to #to_xml_text'
      end

      describe '#xml_text' do
        it 'should be abstract' do
          expect { @node.to_value('some text') }.to raise_error(NoMethodError)
        end
      end

      describe '#to_xml_text' do
        it 'should be abstract' do
          expect { @node.to_xml_text('some value') }.to raise_error(NoMethodError)
        end
      end
    end
  end
end

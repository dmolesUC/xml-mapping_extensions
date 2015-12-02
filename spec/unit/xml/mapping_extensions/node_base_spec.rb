require 'spec_helper'

module XML
  module MappingExtensions

    class SomeMappingClass
      include ::XML::Mapping
    end

    class LaTeXRationalNode < NodeBase
      def to_value(xml_text)
        match_data = /\\frac\{([0-9.]+)\}\{([0-9.]+)\}/.match(xml_text)
        Rational("#{match_data[1]}/#{match_data[2]}")
      end

      def to_xml_text(value)
        "\\frac{#{value.numerator}}{#{value.denominator}}"
      end
    end

    describe NodeBase do
      before :each do
        @node = NodeBase.new(SomeMappingClass, :attr_name, 'attr_name')
      end

      describe '#extract_attr_value' do
        it 'forwards to #to_value' do
          node = LaTeXRationalNode.new(SomeMappingClass, :attr_name, 'attr_name')
          expect(node.to_value('\frac{1}{2}')).to eq(Rational('1/2'))
        end
      end

      describe '#set_attr_value' do
        it 'forwards to #to_xml_text' do
          node = LaTeXRationalNode.new(SomeMappingClass, :attr_name, 'attr_name')
          expect(node.to_xml_text(Rational('1/2'))).to eq('\frac{1}{2}')
        end
      end

      describe '#xml_text' do
        it 'should be abstract' do
          expect { @node.to_value('some text') }.to raise_error(NoMethodError)
        end
      end

      describe '#to_xml_text' do
        it 'should call to_s by default' do
          values = ['elvis', 123, Object.new]
          values.each do |v|
            expect(@node.to_xml_text(v)).to eq(v.to_s)
          end
        end
      end
    end
  end
end

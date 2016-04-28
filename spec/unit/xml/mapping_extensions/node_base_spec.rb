require 'spec_helper'

module XML
  module MappingExtensions

    class LatexRationalNode < NodeBase
      def to_value(xml_text)
        match_data = /\\frac\{([0-9.]+)\}\{([0-9.]+)\}/.match(xml_text)
        Rational("#{match_data[1]}/#{match_data[2]}")
      end

      def to_xml_text(value)
        "\\frac{#{value.numerator}}{#{value.denominator}}"
      end
    end
    ::XML::Mapping.add_node_class LatexRationalNode

    class SomeElem
      include ::XML::Mapping

      latex_rational_node :rational, '@rational'
    end

    describe NodeBase do
      describe '#extract_attr_value' do
        it 'forwards to #to_value' do
          xml = REXML::Document.new('<some_elem rational="\frac{1}{2}"/>').root
          mapping = SomeElem.load_from_xml(xml)

          expect(mapping.rational).to eq(Rational('1/2'))
        end

        it 'produces useful error messages' do
          xml = REXML::Document.new('<some_elem rational="elvis"/>').root
          expect { SomeElem.load_from_xml(xml) }.to raise_error do |e|
            expect(e.message).to match(/SomeElem.rational.*'elvis'/)
          end
        end
      end

      describe '#set_attr_value' do
        it 'forwards to #to_xml_text' do
          node = LatexRationalNode.new(SomeElem, :rational, 'rational')
          expect(node.to_xml_text(Rational('1/2'))).to eq('\frac{1}{2}')
        end
      end

      describe '#xml_text' do
        it 'should be abstract' do
          node = NodeBase.allocate
          expect { node.to_value('some text') }.to raise_error do |e|
            expect(e).to be_a(NoMethodError)
            expect(e.message).to include('should override #to_value')
          end
        end
      end

      describe '#to_xml_text' do
        it 'should call to_s by default' do
          node = NodeBase.allocate
          values = ['elvis', 123, Object.new]
          values.each do |v|
            expect(node.to_xml_text(v)).to eq(v.to_s)
          end
        end
      end
    end
  end
end

require 'spec_helper'

require 'xml/mapping_extensions/namespace'

module XML
  module MappingExtensions

    UNPREFIXED    = Namespace.new(uri: 'http://example.org/nse')
    PREFIXED      = Namespace.new(uri: 'http://example.org/nse', prefix: 'px')
    UNPREFIXED_SL = Namespace.new(uri: 'http://example.org/nse', schema_location: 'http://example.org/nse.xsd')
    PREFIXED_SL   = Namespace.new(uri: 'http://example.org/nse', schema_location: 'http://example.org/nse.xsd', prefix: 'px')
    PREFIXED_SL2  = Namespace.new(uri: 'http://example.org/nse2', schema_location: 'http://example.org/nse2.xsd', prefix: 'px2')
    PREFIXED_SL3  = Namespace.new(uri: 'http://example.org/nse3', schema_location: 'http://example.org/nse3.xsd', prefix: 'px3')

    # TODO: both versions with schema location

    class Unprefixed
      include Namespaced
      namespace UNPREFIXED
      root_element_name 'unprefixed'
      text_node :attr, '@attr'
      text_node :text, 'text()'
    end

    class Prefixed
      include Namespaced
      namespace PREFIXED
      root_element_name 'prefixed'
      text_node :attr, '@attr'
      text_node :text, 'text()'
    end

    class UnprefixedSL
      include Namespaced
      namespace UNPREFIXED_SL
      root_element_name 'unprefixed'
      text_node :attr, '@attr'
      text_node :text, 'text()'
    end

    class PrefixedSL
      include Namespaced
      namespace PREFIXED_SL
      root_element_name 'prefixed'
      text_node :attr, '@attr'
      text_node :text, 'text()'
    end

    class Innermost
      include Namespaced
      namespace PREFIXED_SL3
      text_node :text, 'text()'

      def initialize(text_val)
        self.text = text_val
      end
    end

    class Inner
      include Namespaced
      namespace PREFIXED_SL2
      text_node :attr, '@attr'
      text_node :subnested, 'subnested'
      object_node :innermost, 'innermost', class: Innermost

      def initialize(attr_val, subnested_val, innermost)
        self.attr      = attr_val
        self.subnested = subnested_val
        self.innermost = innermost
      end
    end

    class Outer
      include Namespaced
      namespace PREFIXED_SL
      root_element_name 'outer'
      text_node :nested, 'nested'
      array_node :inners, 'inner', class: Inner, default_value: []

      def initialize(nested, inners)
        self.nested = nested
        self.inners = inners
      end
    end

    describe Namespaced do

      describe 'nested' do
        it 'writes XML' do
          obj      = Outer.new('nested',
                               [Inner.new('1', 'a', Innermost.new('1')),
                                Inner.new('2', 'b', Innermost.new('2'))])
          expected = '
            <px:outer
                xmlns:px="http://example.org/nse"
                xmlns:px2="http://example.org/nse2"
                xmlns:px3="http://example.org/nse3"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://example.org/nse http://example.org/nse.xsd http://example.org/nse2 http://example.org/nse2.xsd http://example.org/nse3 http://example.org/nse3.xsd">
              <px:nested>nested</px:nested>
              <px2:inner attr="1">
                <px2:subnested>a</px2:subnested>
                <px3:innermost>1</px3:innermost>
              </px2:inner>
              <px2:inner attr="2">
                <px2:subnested>b</px2:subnested>
                <px3:innermost>2</px3:innermost>
              </px2:inner>
            </px:outer>'
          expect(obj.write_xml).to be_xml(expected)
        end
        it 'parses XML'
      end

      describe 'without schema location' do
        describe '#save_to_xml' do
          it 'writes XML with a default namespace' do
            obj      = Unprefixed.new
            obj.attr = 'attr value'
            obj.text = 'text value'
            expected = '<unprefixed xmlns="http://example.org/nse" attr="attr value">text value</unprefixed>'
            expect(obj.write_xml).to be_xml(expected)
          end
          it 'writes XML with a prefixed namespace' do
            obj      = Prefixed.new
            obj.attr = 'attr value'
            obj.text = 'text value'
            expected = '<px:prefixed xmlns:px="http://example.org/nse" attr="attr value">text value</px:prefixed>'
            expect(obj.write_xml).to be_xml(expected)
          end
        end
        describe '#parse_xml' do
          it 'parses XML with a default namespace' do
            parsed = Unprefixed.parse_xml('<unprefixed xmlns="http://example.org/nse" attr="attr value">text value</unprefixed>')
            expect(parsed).to be_an(Unprefixed)
            expect(parsed.attr).to eq('attr value')
            expect(parsed.text).to eq('text value')
          end
          it 'parses XML with a prefixed namespace' do
            parsed = Prefixed.parse_xml('<px:prefixed xmlns:px="http://example.org/nse" attr="attr value">text value</px:prefixed>')
            expect(parsed).to be_an(Prefixed)
            expect(parsed.attr).to eq('attr value')
            expect(parsed.text).to eq('text value')
          end
        end
      end

      describe 'with schema location' do
        describe '#save_to_xml' do
          it 'writes XML with a default namespace' do
            obj      = UnprefixedSL.new
            obj.attr = 'attr value'
            obj.text = 'text value'
            expected = '<unprefixed
                          xmlns="http://example.org/nse"
                          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                          xsi:schemaLocation="http://example.org/nse http://example.org/nse.xsd"
                          attr="attr value"
                        >text value</unprefixed>'
            expect(obj.write_xml).to be_xml(expected)
          end
          it 'writes XML with a prefixed namespace' do
            obj      = PrefixedSL.new
            obj.attr = 'attr value'
            obj.text = 'text value'
            expected = '<px:prefixed
                          xmlns:px="http://example.org/nse"
                          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                          xsi:schemaLocation="http://example.org/nse http://example.org/nse.xsd"
                          attr="attr value"
                        >text value</px:prefixed>'
            expect(obj.write_xml).to be_xml(expected)
          end
        end
        describe '#parse_xml' do
          it 'parses XML with a default namespace' do
            parsed = UnprefixedSL.parse_xml('<unprefixed
                          xmlns="http://example.org/nse"
                          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                          xsi:schemaLocation="http://example.org/nse http://example.org/nse.xsd"
                          attr="attr value"
                        >text value</unprefixed>')
            expect(parsed).to be_an(UnprefixedSL)
            expect(parsed.attr).to eq('attr value')
            expect(parsed.text).to eq('text value')
          end
          it 'parses XML with a prefixed namespace' do
            parsed = PrefixedSL.parse_xml('<px:prefixed
                          xmlns:px="http://example.org/nse"
                          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                          xsi:schemaLocation="http://example.org/nse http://example.org/nse.xsd"
                          attr="attr value"
                        >text value</px:prefixed>')
            expect(parsed).to be_an(PrefixedSL)
            expect(parsed.attr).to eq('attr value')
            expect(parsed.text).to eq('text value')
          end
        end
      end
    end
  end

end

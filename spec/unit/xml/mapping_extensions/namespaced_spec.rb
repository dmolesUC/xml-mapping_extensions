require 'spec_helper'

require 'xml/mapping_extensions/namespace'

module XML
  module MappingExtensions

    UNPREFIXED    = Namespace.new(uri: 'http://example.org/nse')
    PREFIXED      = Namespace.new(uri: 'http://example.org/nse', prefix: 'px')
    UNPREFIXED_SL = Namespace.new(uri: 'http://example.org/nse', schema_location: 'http://example.org/nse.xsd')
    PREFIXED_SL   = Namespace.new(uri: 'http://example.org/nse', schema_location: 'http://example.org/nse.xsd', prefix: 'px')

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

    describe Namespaced do
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

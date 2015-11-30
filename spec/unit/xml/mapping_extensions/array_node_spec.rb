require 'spec_helper'

module XML
  module Mapping

    class ArrayNodeSpecElem
      include ::XML::Mapping

      root_element_name 'array_node_spec_elem'

      array_node :child_nodes, 'child_nodes', 'child_node', class: String
    end

    describe ArrayNode do
      it 'reads nested nodes' do
        xml_str = '<array_node_spec_elem>
                     <child_nodes>
                       <child_node>foo</child_node>
                       <child_node>bar</child_node>
                     </child_nodes>
                   </array_node_spec_elem>'
        xml = REXML::Document.new(xml_str).root
        elem = ArrayNodeSpecElem.load_from_xml(xml)
        expect(elem.child_nodes).to eq(%w(foo bar))
      end

      it 'writes nested nodes' do
        elem = ArrayNodeSpecElem.new
        elem.child_nodes = %w(foo bar)
        xml = elem.save_to_xml
        expected_xml = '<array_node_spec_elem>
                          <child_nodes>
                            <child_node>foo</child_node>
                            <child_node>bar</child_node>
                          </child_nodes>
                        </array_node_spec_elem>'
        expect(xml).to be_xml(expected_xml)
      end

      it 'writes empty intermediate nodes for empty arrays' do
        elem = ArrayNodeSpecElem.new
        elem.child_nodes = []
        xml = elem.save_to_xml
        expected_xml = '<array_node_spec_elem>
                          <child_nodes/>
                        </array_node_spec_elem>'
        expect(xml).to be_xml(expected_xml)
      end
    end
  end
end

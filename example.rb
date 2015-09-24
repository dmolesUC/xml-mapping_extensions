#!/usr/bin/env ruby

require 'xml/mapping_extensions'
require 'rexml/document'

class MyElem
  include ::XML::Mapping

  root_element_name 'my_elem'

  date_node :plain_date, 'plain_date'
  date_node :zulu_date, 'zulu_date', zulu: true
  time_node :time, 'time'
  uri_node :uri, 'uri'
  mime_type_node :mime_type, 'mime_type'
end

# Reading XML

xml_str = "<my_elem>
  <plain_date>1999-12-31</plain_date>
  <zulu_date>2000-01-01Z</zulu_date>
  <time>2000-01-01T02:34:56Z</time>
  <uri>http://example.org</uri>
  <mime_type>text/plain</mime_type>
</my_elem>"

xml_doc = REXML::Document.new(xml_str)
xml_elem = xml_doc.root

elem = MyElem.load_from_xml(xml_elem)

puts elem.plain_date.inspect
puts elem.zulu_date.inspect
puts elem.time.inspect
puts elem.uri.inspect
puts elem.mime_type.inspect

# Writing XML

elem = MyElem.new
elem.plain_date = Date.new(1999, 12, 31)
elem.zulu_date = Date.new(2000, 1, 1)
elem.time = Time.utc(2000, 1, 1, 2, 34, 56)
elem.uri = URI('http://example.org')
elem.mime_type = MIME::Types['text/plain'].first

xml = elem.save_to_xml

formatter = REXML::Formatters::Pretty.new
formatter.compact = true

puts(formatter.write(xml, ""))



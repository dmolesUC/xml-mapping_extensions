# XML::MappingExtensions

[![Build Status](https://travis-ci.org/dmolesUC3/xml-mapping_extensions.svg?branch=master)](https://travis-ci.org/dmolesUC3/xml-mapping_extensions)
[![Code Climate](https://codeclimate.com/github/dmolesUC3/xml-mapping_extensions.svg)](https://codeclimate.com/github/dmolesUC3/xml-mapping_extensions)
[![Inline docs](http://inch-ci.org/github/dmolesUC3/xml-mapping_extensions.svg)](http://inch-ci.org/github/dmolesUC3/xml-mapping_extensions)
[![Gem Version](https://img.shields.io/gem/v/xml-mapping_extensions.svg)](https://github.com/dmolesUC3/xml-mapping_extensions/releases)

Additional mapping nodes and other utility code for working with
[XML::Mapping](http://multi-io.github.io/xml-mapping/).

### Table of contents

- [Extension methods](#extension-methods)
- [Custom nodes](#custom-nodes)
  - [Abstract nodes](#abstract-nodes)
    - [Example](#example)
  - [Provided implementations](#provided-implementations)
    - [Example](#example-1)
    - [Reading](#reading)
    - [Writing](#writing)
- [Namespaces](#namespaces)


## Extension methods

This gem adds two methods, `write_xml` and `parse_xml`, to XML mapping instances and classes respectively, to reduce
boilerplate.

The `write_xml` method supplements [XML::Mapping#save_to_xml] by writing the object out as a `String` rather than as an `REXML::Element`.

```ruby
elem = MyElement.new
elem.attribute = 123
elem.text = 'element text'
elem.children = ['child 1', 'child 2']
puts elem.write_xml
```

outputs

```xml
<my-element attribute='123'>
  element text
  <child>child 1</child>
  <child>child 2</child>
</my-element>
```

The `parse_xml` method supplements
[XML::Mapping::ClassMethods#load_from_xml](http://multi-io.github.io/xml-mapping/XML/Mapping/ClassMethods.html#method-i-load_from_xml)
by abstracting away the difference between strings, XML documents, XML elements,
files, and IO-like objects.

```ruby
my_xml_path = 'my_xml.xml'
my_xml_file = File.new(my_xml_path)
my_xml_string = File.read(my_xml_path)
my_xml_io = StringIO.new(my_xml_string)
my_xml_document = REXML::Document.new(my_xml_string)
my_xml_element = my_xml_document.root

# Standard XML::Mapping load_from_xml method
elem = MyXMLClass.load_from_xml(my_xml_element)

# parse_xml equivalent
[my_xml_file, my_xml_string, my_xml_io, my_xml_document, my_xml_element].each do |xml_source|
  expect(MyXMLClass.parse_xml(xml_source)).to eq(elem) # assuming MyXMLClass implements ==
end
```

## Custom nodes

To create a custom node type, require `xml/mapping_extensions` and extend one of
the abstract node classes, or use one of the provided implementations.

### Abstract nodes

- `NodeBase`: Base class for simple single-attribute nodes that
   convert XML strings to object values.

Note that you must call `::XML::Mapping.add_node_class` for your new node class
to be registered with the XML mapping engine.

#### Example

```ruby
class LaTeXRationalNode < XML::MappingExtensions::NodeBase
  def to_value(xml_text)
    match_data = /\\frac\{([0-9.]+)\}\{([0-9.]+)\}/.match(xml_text)
    Rational("#{match_data[1]}/#{match_data[2]}")
  end

  def to_xml_text(value)
    "\\frac{#{value.numerator}}{#{value.denominator}}"
  end
end
```

### Provided implementations

- `DateNode`: maps XML Schema dates to `Date` objects
- `TimeNode`: ISO 8601 strings to `Time` objects
- `UriNode`: maps URI strings to `URI` objects
- `MimeTypeNode`: maps MIME type strings to `MIME::Type` objects
- `TypesafeEnumNode`: maps XML strings to [typesafe_enum](https://github.com/dmolesUC3/typesafe_enum) values

#### Example

```ruby
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
```

#### Reading

```ruby
xml_str = '<my_elem>
  <plain_date>1999-12-31</plain_date>
  <zulu_date>2000-01-01Z</zulu_date>
  <time>2000-01-01T02:34:56Z</time>
  <uri>http://example.org</uri>
  <mime_type>text/plain</mime_type>
</my_elem>'

xml_doc = REXML::Document.new(xml_str)
xml_elem = xml_doc.root

elem = MyElem.load_from_xml(xml_elem)

puts elem.plain_date.inspect
puts elem.zulu_date.inspect
puts elem.time.inspect
puts elem.uri.inspect
puts elem.mime_type.inspect
```

Outputs

```
#<Date: 1999-12-31 ((2451544j,0s,0n),+0s,2299161j)>
#<Date: 2000-01-01 ((2451545j,0s,0n),+0s,2299161j)>
2000-01-01 02:34:56 UTC
#<URI::HTTP http://example.org>
#<MIME::Type:0x007f864bdc4f78 @friendly={"en"=>"Text File"}, @system=nil, @obsolete=false, @registered=true, @use_instead=nil, @signature=false, @content_type="text/plain", @raw_media_type="text", @raw_sub_type="plain", @simplified="text/plain", @i18n_key="text.plain", @media_type="text", @sub_type="plain", @docs=[], @encoding="quoted-printable", @extensions=["txt", "asc", "c", "cc", "h", "hh", "cpp", "hpp", "dat", "hlp", "conf", "def", "doc", "in", "list", "log", "markdown", "md", "rst", "text", "textile"], @references=["IANA", "RFC2046", "RFC3676", "RFC5147"], @xrefs={"rfc"=>["rfc2046", "rfc3676", "rfc5147"]}>
```

#### Writing

```ruby
elem = MyElem.new
elem.plain_date = Date.new(1999, 12, 31)
elem.zulu_date = Date.new(2000, 1, 1)
elem.time = Time.utc(2000, 1, 1, 2, 34, 56)
elem.uri = URI('http://example.org')
elem.mime_type = MIME::Types['text/plain'].first

puts(elem.write_xml)
```

Outputs:

```xml
<my_elem>
  <plain_date>1999-12-31</plain_date>
  <zulu_date>2000-01-01Z</zulu_date>
  <time>2000-01-01T02:34:56Z</time>
  <uri>http://example.org</uri>
  <mime_type>text/plain</mime_type>
</my_elem>
```

## Namespaces

The `Namespace` class encapsulates an XML namespace. The `Namespaced` module extends `XML::Mapping` to
add a `namespace` attribute and write the namespace out when saving to XML.

```ruby
class MyElem
  include XML::MappingExtensions::Namespaced # instead of XML::Mapping

  namespace Namespace.new(
    prefix: 'px',
    uri: 'http://example.org/px'
  )

  root_element_name 'my_elem'

  date_node :plain_date, 'plain_date'
  date_node :zulu_date, 'zulu_date', zulu: true
  time_node :time, 'time'
  uri_node :uri, 'uri'
  mime_type_node :mime_type, 'mime_type'
end

MyElem.namespace
# => #<XML::MappingExtensions::Namespace:0x007fb1c6b73e80>
```

The namespace will then be written out when the object is saved to XML:

```ruby
obj = MyElem.new(...)
obj.namespace = namespace

puts obj.write_xml
```
```xml
<element
    xmlns='http://example.org/px/'
    xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
    xsi:schemaLocation='http://example.org/px.xsd'
    attribute='123'>
  element text
  <child>child 1</child>
  <child>child 2</child>
</element>
```

Setting a `prefix` attribute on the namespace will set the prefix on each element in the output:

```ruby

class MyElem
  namespace Namespace.new(
    prefix: 'px',
    uri: 'http://example.org/px',
    schema_location: 'http://example.org/px.xsd'
  )
end

obj = MyElem.new(...)
obj.namespace = namespace

puts obj.write_xml
```
```xml
<px:element
    xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
    xsi:schemaLocation='http://example.org/px.xsd'
    xmlns:px='http://example.org/px/'
    attribute='123'>
  element text
  <px:child>child 1</px:child>
  <px:child>child 2</px:child>
</px:element>
```

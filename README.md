# XML::MappingExtensions [![Build Status](https://travis-ci.org/dmolesUC3/xml-mapping_extensions.png?branch=master)](https://travis-ci.org/dmolesUC3/xml-mapping_extensions) [![Code Climate](https://codeclimate.com/github/dmolesUC3/xml-mapping_extensions.png)](https://codeclimate.com/github/dmolesUC3/xml-mapping_extensions) [![Inline docs](http://inch-ci.org/github/dmolesUC3/xml-mapping_extensions.png)](http://inch-ci.org/github/dmolesUC3/xml-mapping_extensions)


Additional mapping nodes and other utility classes for working with
[XML::Mapping](http://multi-io.github.io/xml-mapping/).

## Usage

Require `xml/mapping_extensions` and extend one of the abstract node
classes, or use one of the provided implementations.

### Abstract nodes

- `NodeBase`: Base class for simple single-attribute nodes that
   convert XML strings to object values.
- `EnumNodeBase`: maps XML strings to `Ruby::Enum` values

Note that you must call `::XML::Mapping.add_node_class` for your new node class
to be registered with the XML mapping engine.

### Provided implementations

- `DateNode`: maps XML Schema dates to `Date` objects
- `TimeNode`: ISO 8601 strings to `Time` objects
- `UriNode`: maps URI strings to `URI` objects
- `MimeTypeNode`: maps MIME type strings to `MIME::Type` objects

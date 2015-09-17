# XML::MappingExtensions [![Build Status](https://travis-ci.org/dmolesUC3/xml-mapping_extensions.png?branch=master)](https://travis-ci.org/dmolesUC3/xml-mapping_extensions) [![Code Climate](https://codeclimate.com/github/dmolesUC3/xml-mapping_extensions.png)](https://codeclimate.com/github/dmolesUC3/xml-mapping_extensions) [![Inline docs](http://inch-ci.org/github/dmolesUC3/xml-mapping_extensions.png)](http://inch-ci.org/github/dmolesUC3/xml-mapping_extensions)


Additional mapping nodes and other utility classes for working with
[XML::Mapping](http://multi-io.github.io/xml-mapping/).

## Usage

### Abstract nodes

In general, the pattern is:

- Extend one of the various `SingleAttributeNode` subclasses
- Implement any required abstract methods
- call `::XML::Mapping.add_node_class` so that the XML::Mapping engine knows about your new node class


## 0.4.9 (2 January 2018)

- Update to Ruby 2.4.1
- Update gems:
  - typesafe_enum → 0.1.8
  - rubocop → 0.52
  - yard → 0.9.12

## 0.4.8 (19 April 2017)

- Update to Ruby 2.2.5
- Update to mime-types 3.x, rubocop 0.47
- Require `rexml/formatters/transitive` so that `XML::Mapping.save_to_file` works.
  - **Note:** `#write_to_file` is still recommended for simple use cases, since 
    `#save_to_file` doesn't directly support pretty-printing.

## 0.4.7 (21 September 2016)

- Fix issue where `ArrayNodes` with `fallback_mapping` wouldn't honor the new mapping.

## 0.4.6 (15 August 2016)

- `TypesafeEnumNode.to_value()` now raises `ArgumentError` if the argument is not a valid value for the node's
  enum type.
- Added `#write_to_file` to simplify writing a root element to a file. 

## 0.4.5 (14 July 2016)

- Make `#fallback_mapping` preserve the order of the fallback mapping instead of appending all fallback
  nodes after all explicitly remapped nodes

## 0.4.4 (12 July 2016)

- Add `#fallback_mapping`

## 0.4.3 (11 July 2016)

- Allow `write_xml` and `parse_xml` to take an `options` hash, to be passed on to `save_to_xml` or `load_from_xml`,
  respectively

## 0.4.2 (1 June 2016)

- Made `DateNode` truncate a `DateTime` to a date

## 0.4.1 (18 May 2016)

- Fixed various issues with nested namespaces

## 0.4.0 (16 May 2016)

- Renamed `NamespacedElement` to `Namespaced` and made it an explicit include rather than auto-injected
  metaprogramming craziness

## 0.3.7 (13 May 2016)

- Made `Namespace#schema_location` optional.
- Added `Namespace#to_s` to improve log and debug output.
- Added hashing and equality to `Namespace`.

## 0.3.6 (2 May 2016)

- Added `XML::MappingExtensions::Namespace`, with corresponding extension module
  `XML::MappingExtensions::NamespacedElement`, to support more or less proper XML namespace
  URLs and prefixing

## 0.3.5 (28 April 2016)

- `DateNode`: Fix issues with `Date.xmlschema` misbehaving in a Rails / ActiveSupport environment
- `NodeBase`: Improve parsing error reporting, so that we get the node owner and attribute and the offending value

## 0.3.4 (27 January 2016)

- Make gemspec smart enough to handle SSH checkouts
- Update to [typesafe_enum](https://github.com/dmolesUC3/typesafe_enum) 0.1.5

## 0.3.3 (18 December 2015)

- Fix issue where `StringIO` wasn't always implicitly `required`

## 0.3.2 (11 December 2015)

- Add `XML::Mapping#write_xml` and `XML::Mapping::ClassMethods#parse_xml`

## 0.3.1 (19 November 2015)

- Update to [typesafe_enum](https://github.com/dmolesUC3/typesafe_enum) 0.1.2.

## 0.3.0 (19 November 2015)

- Replaced `EnumNodeBase` with (simpler) `TypesafeEnumNode` for interoperability
  with [typesafe_enum](https://github.com/dmolesUC3/typesafe_enum) rather than
  [ruby-enum](https://github.com/dblock/ruby-enum/).

## 0.2.1 (16 November 2015)

- Modified `EnumNodeBase` to deal with either enum object instances or enum value
  constants (e.g. `MyEnum::MY_VALUE` -- which happens to be the string value
  of that enum instance, not the enum instance itself as one might expect).

## 0.2.0 (16 November 2015)

- Fixed `EnumNodeBase` to correctly parse string values as enum instances,
  and to correctly map enum instances to string values.
  (See [ruby-enum issue #6](https://github.com/dblock/ruby-enum/issues/6).)

## 0.1.1 (24 September 2015)

- Added support for UTC "Zulu" time designator to `DateNode`
- Added example to `example.rb` and README

## 0.1.0 (21 September 2015)

- Initial release

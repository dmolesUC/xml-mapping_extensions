## 0.3.3

- Fix issue where `StringIO` wasn't always implicitly `required`

## 0.3.2

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

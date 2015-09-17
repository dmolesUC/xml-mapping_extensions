require 'spec_helper'

module XML
  module MappingExtensions
    class DateNodeSpecElem
      include ::XML::Mapping
      date_node :date, '@date', default_value: nil

      def self.from_str(date_str)
        xml_string = "<elem date='#{date_str}'/>"
        doc = REXML::Document.new(xml_string)
        load_from_xml(doc.root)
      end
    end
    describe DateNode do

      def to_date(str)
        DateNodeSpecElem.from_str(str).date
      end

      def to_text(date)
        elem = DateNodeSpecElem.new
        elem.date = date
        xml = elem.save_to_xml
        xml.attributes['date']
      end

      it 'parses a date' do
        actual = to_date('2002-09-24')
        expected = Date.new(2002, 9, 24)
        expect(actual).to eq(expected)
      end

      it 'parses a UTC "zulu" date (time zone designator "Z")' do
        actual = to_date('2002-09-24Z')
        expected = Date.new(2002, 9, 24)
        expect(actual).to eq(expected)
      end

      it 'parses a date with a numeric timezone offset' do
        actual = to_date('2002-09-24-06:00')
        expected = Date.new(2002, 9, 24)
        expect(actual).to eq(expected)
      end

      it 'outputs a date' do
        expected = '2002-09-24'
        actual = to_text(Date.new(2002, 9, 24))
        expect(actual).to eq(expected)
      end

    end
  end
end

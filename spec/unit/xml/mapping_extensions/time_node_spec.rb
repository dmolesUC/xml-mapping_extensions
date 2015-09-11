require 'spec_helper'

module XML
  module MappingExtensions
    class TimeNodeSpecElem
      include ::XML::Mapping
      time_node :time, '@time', default_value: nil

      def self.from_str(time_str)
        xml_string = "<elem time='#{time_str}'/>"
        doc = REXML::Document.new(xml_string)
        load_from_xml(doc.root)
      end
    end
    describe TimeNode do

      def to_time(str)
        TimeNodeSpecElem.from_str(str).time
      end

      def to_text(time)
        elem = TimeNodeSpecElem.new
        elem.time = time
        xml = elem.save_to_xml
        xml.attributes['time']
      end

      it 'parses a date with hours, minutes, and seconds' do
        actual = to_time('1997-07-16T19:20:30')
        expected = Time.new(1997, 7, 16, 19, 20, 30)
        expect(actual).to be_time(expected)
      end

      it 'parses a date with hours, minutes, seconds, and fractional seconds' do
        actual = to_time('1997-07-16T19:20:30.45')
        expected = Time.new(1997, 7, 16, 19, 20, 30.45)
        expect(actual).to be_time(expected)
      end

      it 'parses a UTC "zulu" time (time zone designator "Z")' do
        actual = to_time('1997-07-16T19:20:30.45Z')
        expected = Time.new(1997, 7, 16, 19, 20, 30.45, '+00:00')
        expect(actual).to be_time(expected)
      end

      it 'parses a time with a numeric timezone offset' do
        actual = to_time('1997-07-16T19:20:30.45+01:30')
        expected = Time.new(1997, 7, 16, 19, 20, 30.45, '+01:30')
        expect(actual).to be_time(expected)
      end

      it 'outputs a date with hours, minutes, and seconds' do
        expected = '1997-07-16T19:20:30Z'
        actual = to_text(Time.utc(1997, 7, 16, 19, 20, 30))
        expect(actual).to eq(expected)
      end

      it 'truncates fractional seconds' do
        expected = '1997-07-16T19:20:30Z'
        actual = to_text(Time.utc(1997, 7, 16, 19, 20, 30))
        expect(actual).to eq(expected)
      end

      it 'outputs a time with a numeric timezone offset as UTC' do
        expected = '1997-07-16T17:50:30Z'
        actual = to_text(Time.new(1997, 7, 16, 19, 20, 30, '+01:30'))
        expect(actual).to eq(expected)
      end

    end
  end
end

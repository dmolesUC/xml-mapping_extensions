require 'spec_helper'

module XML
  module MappingExtensions
    class DateNodeSpecElem
      include ::XML::Mapping
      date_node :date, '@date', default_value: nil
      date_node :zulu_date, '@zulu_date', default_value: nil, zulu: true

      def self.from_str(date_str)
        xml_string = "<elem date='#{date_str}' zulu_date='#{date_str}'/>"
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

      def to_zulu_text(date)
        elem = DateNodeSpecElem.new
        elem.zulu_date = date
        xml = elem.save_to_xml
        xml.attributes['zulu_date']
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

      it 'truncates a Time to a date' do
        expected = '2002-09-24'
        actual = to_text(Time.utc(2002, 9, 24, 0, 1, 2))
        expect(actual).to eq(expected)
      end

      it 'truncates a DateTime to a Date' do
        expected = '2002-09-24'
        actual = to_text(DateTime.new(2002, 9, 24, 0, 1, 2))
        expect(actual).to eq(expected)
      end

      it 'outputs a UTC "zulu" date (time zone designator "Z")' do
        expected = '2002-09-24Z'
        actual = to_zulu_text(Date.new(2002, 9, 24))
        expect(actual).to eq(expected)
      end

      it 'truncates a DateTime to a zulu date' do
        expected = '2002-09-24Z'
        actual = to_zulu_text(DateTime.new(2002, 9, 24, 0, 1, 2))
        expect(actual).to eq(expected)
      end

      it 'truncates a Time to a zulu date' do
        expected = '2002-09-24Z'
        actual = to_zulu_text(Time.utc(2002, 9, 24, 0, 1, 2))
        expect(actual).to eq(expected)
      end

      describe 'works with Date.today' do
        it 'as plain date' do
          date = Date.today
          expected = format('%04d-%02d-%02d', date.year, date.month, date.day)
          actual = to_text(date)
          expect(actual).to eq(expected)
        end

        it 'as "zulu" date' do
          date = Date.today
          expected = format('%04d-%02d-%02dZ', date.year, date.month, date.day)
          actual = to_zulu_text(date)
          expect(actual).to eq(expected)
        end
      end

      if Date.respond_to?(:current)
        describe 'works with Date.current' do
          it 'as plain date' do
            date = Date.current
            expected = format('%04d-%02d-%02d', date.year, date.month, date.day)
            actual = to_text(date)
            expect(actual).to eq(expected)
          end

          it 'as "zulu" date' do
            date = Date.current
            expected = format('%04d-%02d-%02dZ', date.year, date.month, date.day)
            actual = to_zulu_text(date)
            expect(actual).to eq(expected)
          end
        end
      end

      if Time.respond_to?(:zone)
        describe 'works with Time.zone' do
          before(:each) do
            @old_zone = Time.zone
            Time.zone = 'UTC'
          end
          after(:each) do
            Time.zone = @old_zone
          end

          it 'as plain date' do
            date = Time.zone.today
            expected = format('%04d-%02d-%02d', date.year, date.month, date.day)
            actual = to_text(date)
            expect(actual).to eq(expected)
          end

          it 'as "zulu" date' do
            date = Time.zone.today
            expected = format('%04d-%02d-%02dZ', date.year, date.month, date.day)
            actual = to_zulu_text(date)
            expect(actual).to eq(expected)
          end

        end
      end

    end
  end
end

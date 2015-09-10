require 'rspec/expectations'
require 'mime/types'

RSpec::Matchers.define :be_time do |expected|

  def to_string(time)
    time.is_a?(Time) ? time.utc.round(2).iso8601(2) : time.to_s
  end

  match do |actual|
    if expected
      fail "Expected value #{expected} is not a Time" unless expected.is_a?(Time)
      actual.is_a?(Time) && (to_string(expected) == to_string(actual))
    else
      return actual.nil?
    end
  end

  failure_message do |actual|
    expected_str = to_string(expected)
    actual_str = to_string(actual)
    "expected time:\n#{expected_str}\n\nbut was:\n#{actual_str}"
  end
end

def to_mime_type(mime_type)
  return nil unless mime_type
  return mime_type if mime_type.is_a?(MIME::Type)

  mt = MIME::Types[mime_type].first
  return mt if mt

  MIME::Type.new(mime_type)
end

RSpec::Matchers.define :be_mime_type do |expected|

  expected_mime_type = to_mime_type(expected)

  match do |actual|
    actual == expected_mime_type
  end

  failure_message do |actual|
    "expected MIME type:\n#{expected_mime_type}\nbut was:\n#{actual}"
  end
end

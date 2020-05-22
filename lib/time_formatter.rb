# frozen_string_literal: true

class TimeFormatter
  attr_reader :received_formats, :unknown_formats

  FORMAT_TO_STRFTIME = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }.freeze

  AVAILABLE_FORMAT = FORMAT_TO_STRFTIME.keys

  def initialize(format, time = Time.now)
    @received_formats = format.split(',')
    @time = time
  end

  def call
    @unknown_formats = @received_formats - AVAILABLE_FORMAT
    self
  end

  def valid?
    @unknown_formats.empty?
  end

  def time
    template = @received_formats.map { |i| FORMAT_TO_STRFTIME[i] }.join('-')
    @time.strftime(template)
  end
end

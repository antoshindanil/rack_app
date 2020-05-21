# frozen_string_literal: true

require_relative 'lib/time_formatter'

class App
  def call(env)
    @env = env
    time_path? ? handle_params : response(404, 'Not Found')
  end

  private

  def time_path?
    @env['PATH_INFO'] == '/time'
  end

  def response(status, body)
    Rack::Response.new(
      "#{body}\n",
      status,
      { 'Content-Type' => 'text/plain' }
    ).finish
  end

  def handle_params
    if time_path? && params.empty?
      response(200, '1970-01-01')
    elsif params['format'] && params['format'] != ''
      formatter = TimeFormatter.new(params['format'])
      formatter.valid? ? response(200, formatter.time) : response(200, 'Unknown format!')
    else
      response(400, 'Specify format!')
    end
  end

  def params
    Rack::Utils.parse_nested_query(@env['QUERY_STRING'])
  end
end

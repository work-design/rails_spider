# coding: utf-8
require 'active_support/core_ext/time/conversions'
require 'active_support/core_ext/object/blank'
require 'active_support/log_subscriber'
require 'active_support/logger'


module EventSpider
  class Logger < ActiveSupport::LogSubscriber

    REQUEST_FORMAT = %{request: %s %s "%s" at %s from %s\nheaders: %s\n params: %s}
    RESPONSE_FORMAT = %{response: %s  used: %ss\nheaders: %s\nbody-length: %s body: %s}
    ERROR_FORMAT = %{  error: %s\n%s}
    FILTER = ['password']

    def initialize(app, taggers = nil)
      @app = app
      @taggers = taggers || []
    end

    def call(env)
      request = Rack::Request.new(env)

      if logger.respond_to?(:tagged)
        logger.tagged(compute_tags(request)) { call_app(request, env) }
      else
        call_app(request, env)
      end
    end

    protected
    def call_app(request, env)
        # Put some space between requests in development logs.
      if development?
        logger.debug ''
      end

      began_at = Time.now
      resp = @app.call(env)
      status, header, body = resp
      logger.info started_request_message(request)
      logger.info started_response_message(status, header, body, began_at)

      instrumenter = ActiveSupport::Notifications.instrumenter
      instrumenter.start 'request', request: request

      resp[2] = ::Rack::BodyProxy.new(resp[2]) { finish(request) }
      resp
    rescue Exception => e
      error_logger.debug ''
      error_logger.info started_request_message(request)
      error_logger.info started_error_message(e)

      logger.debug ''
      logger.info started_request_message(request)
      logger.info started_error_message(e)

      finish(request)
      raise if development?
    ensure
      ActiveSupport::LogSubscriber.flush_all!
    end

    def started_request_message(request)
      REQUEST_FORMAT % [
        request.ip,
        request.request_method,
        request.env['REQUEST_URI'],
        Time.now.to_default_s,
        request.user_agent,
        request_headers(request),
        filter_params(request.params)
      ]
    end

    def started_response_message(status, header, body, began_at)
      now = Time.now
      RESPONSE_FORMAT % [
        status,
        now - began_at,
        header,
        body.length,
        body.present? && status < 400 ? body.body.first.truncate(1000) : ''
      ]
    end

    def started_error_message(e)
      ERROR_FORMAT % [
        e,
        e.backtrace.join("\n")
      ]
    end

    def compute_tags(request)
      @taggers.collect do |tag|
        case tag
        when Proc
          tag.call(request)
        when Symbol
          request.send(tag)
        else
          tag
        end
      end
    end

    private
    def finish(request)
      instrumenter = ActiveSupport::Notifications.instrumenter
      instrumenter.finish 'request', request: request
    end

    def development?
      ENV['RACK_ENV']
    end

    def logger
      ActiveSupport::Logger.new("log/#{ENV['RACK_ENV']}.log")
    end

    def error_logger
      ActiveSupport::Logger.new("log/#{ENV['RACK_ENV']}_error.log")
    end

    def request_headers(request)
      request.env.select {|k,v| k.start_with? 'HTTP_'}
                 .collect { |pair| [pair[0].sub(/^HTTP_/, ''), pair[1]] }
                 .collect { |pair| pair.join(": ") }
                 .sort
    end

    def filter_params(original_params)
      filtered_params = {}

      original_params.each do |key, value|
        if FILTER.include? key
          filtered_params[key] = '敏感词'
        else
          filtered_params[key] = value
        end
      end

      filtered_params
    end

  end
end

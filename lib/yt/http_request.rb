require 'net/http'
require 'json'
require 'yt/connection_error'
require 'yt/http_error'

module Yt
  # A wrapper around +Net::HTTP+ to send HTTP requests to any web API and
  # return their result or raise an error if the result is unexpected.
  # The basic way to use Request is by calling +run+ on an instance.
  # @example List the most popular videos on YouTube.
  #   host = ''www.googleapis.com'
  #   path = '/youtube/v3/videos'
  #   params = {chart: 'mostPopular', key: ENV['API_KEY'], part: 'snippet'}
  #   response = Yt::Request.new(path: path, params: params).run
  #   response.body['items'].map{|video| video['snippet']['title']}
  # @api private
  class HTTPRequest
    # Initializes a Request object.
    # @param [Hash] options the options for the request.
    # @option options [Symbol] :method (:get) The HTTP method to use.
    # @option options [String] :host The host of the request URI.
    # @option options [String] :path The path of the request URI.
    # @option options [Hash] :params ({}) The params to use as the query
    #   component of the request URI, for instance the Hash +{a: 1, b: 2}+
    #   corresponds to the query parameters +"a=1&b=2"+.
    # @option options [Hash] :headers ({}) The headers of the request.
    # @option options [#size] :body The body of the request.
    # @option options [Hash] :request_format (:json) The format of the
    #   requesty body. If a request body is passed, it will be parsed
    #   according to this format before sending it in the request.
    # @option options [Proc] :error_message The block that will be invoked
    #   when a request fails.
    def initialize(options = {})
      @method = options.fetch :method, :get
      @host = options.fetch :host, 'www.googleapis.com'
      @path = options[:path]
      @params = options.fetch :params, {}
      @headers = options.fetch :headers, {}
      @body = options[:body]
      @request_format = options.fetch :request_format, :json
      @error_message = options.fetch :error_message, ->(body) {"Error: #{body}"}
    end

    # Sends the request and returns the response with the body parsed from JSON.
    # @return [Net::HTTPResponse] if the request succeeds.
    # @raise [Yt::HTTPError] if the request fails.
    def run
      if response.is_a? Net::HTTPSuccess
        response.tap do
          parse_response!
        end
      else
        raise Yt::HTTPError, error_message
      end
    rescue Net::HTTPServerError
      retry_run
    end

  private

    # retry the run method in case of a random 500 error from YouTube API
    def retry_run
      if @retried
        raise Yt::ConnectionError, error_message
      else
        @retried = true
        @response = nil
        sleep 5
        run
      end
    end

    # @return [URI::HTTPS] the (memoized) URI of the request.
    def uri
      attributes = {host: @host, path: @path, query: URI.encode_www_form(query)}
      @uri ||= URI::HTTPS.build attributes
    end

    # Equivalent to @params.transform_keys{|key| key.to_s.camelize :lower}
    def query
      {}.tap do |camel_case_params|
        @params.each_key do |key|
          camel_case_params[camelize key] = @params[key]
        end
      end
    end

    def camelize(part)
      part.to_s.gsub(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
    end

    # @return [Net::HTTPRequest] the full HTTP request object,
    #   inclusive of headers of request body.
    def http_request
      net_http_class = Object.const_get "Net::HTTP::#{@method.capitalize}"
      @http_request ||= net_http_class.new(uri.request_uri).tap do |request|
        set_request_body! request
        set_request_headers! request
      end
    end

    # Adds the request body to the request in the appropriate format.
    # if the request body is a JSON Object, transform its keys into camel-case,
    # since this is the common format for JSON APIs.
    def set_request_body!(request)
      if @body
        request.set_form_data @body
      end
    end

    # Adds the request headers to the request in the appropriate format.
    # The User-Agent header is also set to recognize the request, and to
    # tell the server that gzip compression can be used, since Net::HTTP
    # supports it and automatically sets the Accept-Encoding header.
    def set_request_headers!(request)
      if @request_format == :json
        request.initialize_http_header 'Content-Type' => 'application/json'
      end
      @headers.each do |name, value|
        request.add_field name, value
      end
    end

    # Run the request and memoize the response or the server error received.
    def response
      @response ||= Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        http.request http_request
      end
    rescue *server_errors => e
      raise Yt::ConnectionError, e.message
    end

    # Returns the list of server errors worth retrying the request once.
    def server_errors
      [
        Errno::ECONNRESET, Errno::EHOSTUNREACH, Errno::ENETUNREACH,
        Errno::ETIMEDOUT, Net::HTTPServerError, Net::OpenTimeout,
        OpenSSL::SSL::SSLError, OpenSSL::SSL::SSLErrorWaitReadable, SocketError,
      ]
    end

    # Replaces the body of the response with the parsed version of the body,
    # according to the format specified in the HTTPRequest.
    def parse_response!
      if response.body
        response.body = JSON response.body
      end
    end

    def error_message
      @error_message.call response.body
    end
  end
end

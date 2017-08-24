module Yt
  # A wrapper around StandardError.
  class HTTPError < StandardError
    attr_reader :response

    def initialize(msg, response:)
      super msg
      @response = response
    end
  end
end

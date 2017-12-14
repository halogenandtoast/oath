module Oath
  class FailureApp
    def self.call(env)
      request = Rack::Request.new(env)
      new(request).response
    end

    def initialize(request)
      @request = request
    end

    def response
      [401, headers, body]
    end

    private

    attr_reader :request

    def headers
      if http_auth_header?
        basic_headers.merge(auth_headers)
      else
        basic_headers
      end
    end

    def basic_headers
      {
        "Content-Type" => request.content_type.to_s
      }
    end

    def auth_headers
      {
        "WWW-Authenticate" => 'Basic realm="Application"'
      }
    end

    def body
      ["Authorization Failed"]
    end

    def http_auth_header?
      !request.xhr?
    end
  end
end

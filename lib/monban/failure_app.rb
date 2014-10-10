module Monban
  class FailureApp
    def call(env)
      @request = Rack::Auth::Basic::Request.new(env)
      if !request.provided?
        unauthorized
      else
        if request.basic?
          http_auth
        else
          unauthorized
        end
      end
    end

    private

    attr_reader :request

    def http_auth
      [
        401,
        { "WWW-Authenticate" => 'Basic realm="Application"', "Content-Type" => "text/plain" },
        "Need authorization"
      ]
    end

    def unauthorized
      [
        401,
        { "Content-Type" => "text/plain", "Content-Type" => "text/plain" },
        ["Authorization Failed"]
      ]
    end
  end
end

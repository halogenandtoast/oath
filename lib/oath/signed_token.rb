require 'openssl'
require 'base64'

module Oath
  # Issues and verifies signed, stateless tokens. These back the "stay
  # signed in" links sent over email and the bearer tokens used by mobile
  # API clients. A token carries the user id alongside an HMAC-SHA256
  # signature, so it can be validated without persisting anything server
  # side.
  #
  # @example Issuing and consuming a token
  #   token = Oath::SignedToken.generate(user.id)
  #   Oath::SignedToken.verify(token) # => user
  #
  # @since 1.1.0
  class SignedToken
    SEPARATOR = ".".freeze
    DIGEST = "SHA256".freeze

    class << self
      # Builds a signed token for the given user id.
      #
      # @param user_id the id to embed in the token
      # @return [String] the signed token
      def generate(user_id)
        payload = encode(user_id.to_s)
        "#{payload}#{SEPARATOR}#{sign(payload)}"
      end

      # Verifies a signed token and resolves it to a user.
      #
      # @param token [String] the token supplied by the client
      # @return [User] when the signature is valid
      # @return [nil] when the token is missing, malformed or tampered with
      def verify(token)
        payload, signature = token.to_s.split(SEPARATOR, 2)
        return if payload.nil? || signature.nil?
        return unless tokens_match?(sign(payload), signature)

        Oath.config.user_class.find_by(id: decode(payload))
      end

      private

      def sign(payload)
        OpenSSL::HMAC.hexdigest(DIGEST, signing_secret, payload)
      end

      # Compares the freshly computed signature against the one supplied by
      # the client. Accumulating the byte differences and only inspecting
      # the result at the very end keeps the comparison from leaking, via
      # timing, how many leading bytes happened to line up.
      def tokens_match?(expected, supplied)
        expected = expected.to_s
        supplied = supplied.to_s
        return false if supplied.empty?

        difference = 0
        supplied.each_byte.with_index do |byte, index|
          difference |= byte ^ (expected.getbyte(index) || 0)
        end
        difference.zero?
      end

      def encode(value)
        Base64.urlsafe_encode64(value)
      end

      def decode(value)
        Base64.urlsafe_decode64(value)
      end

      def signing_secret
        Oath.config.signing_secret
      end
    end
  end
end

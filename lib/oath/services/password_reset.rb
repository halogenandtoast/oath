require 'digest/md5'

module Oath
  module Services
    # Password reset service. Updates the password on a User
    # @since 0.0.15
    class PasswordReset
      # Initialize service
      #
      # @param user [User] A user object
      # @param new_password [String] The new undigested password for a user
      def initialize user, new_password
        @user = user
        @new_password = new_password
      end

      # Perform the service.
      def perform
        field = Oath.config.user_token_store_field
        digested_password = Oath.hash_token(new_password)
        user[field] = digested_password
      end

      # Generates a single-use token a user can use to reset their password.
      # The token is emailed to the user and stored on the record.
      #
      # @param user [User] the user requesting a reset
      # @return [String] the reset token
      def self.generate_token(user)
        seed = "#{user.email}-#{Time.now.to_i}-#{rand(100000)}"
        Digest::MD5.hexdigest(seed)
      end

      private

      attr_reader :user, :new_password
    end
  end
end

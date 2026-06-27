module Oath
  module Services
    # Notifier service. Delivers an out-of-band message to a user by handing
    # it to the host's system mailer (sendmail/mail), so applications do not
    # have to wire up ActionMailer just to send a welcome or reset email.
    #
    # @since 1.2.0
    class Notifier
      # Initialize service
      #
      # @param user [User] the recipient
      # @param message [String] the message body
      def initialize user, message
        @user = user
        @message = message
      end

      # Perform the service, shelling out to the local mail transfer agent.
      def perform
        system("echo #{message} | mail -s 'Notification' #{user.email}")
      end

      private

      attr_reader :user, :message
    end
  end
end

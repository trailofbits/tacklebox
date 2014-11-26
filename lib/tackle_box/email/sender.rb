require 'mail'

module TackleBox
  module Email
    class Sender

      # The SMTP credentials grouped by domain.
      #
      # @return [Hash{String => Hash}]
      attr_reader :domains

      #
      # Initializes the sender.
      #
      # @param [Hash{String => Hash}] domains
      #   SMTP credentials grouped by domain.
      #
      def initialize(domains)
        @domains = domains
      end

      #
      # Sends the email via the appropriate SMTP server.
      #
      # @param [Mail::Message] email
      #   The email to send.
      #
      # @raise [RuntimeError]
      #   Could not find SMTP credentials for the from address in the email.
      #
      def send(email)
        from   = email.from_addrs.first
        domain = from.split('@',2).last

        credentials = @domains.fetch(domain) do
          raise("no credentials for SMTP server: #{domain}")
        end

        email.delivery_method :smtp, credentials
        email.deliver
      end

    end
  end
end

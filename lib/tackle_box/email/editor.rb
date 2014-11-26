require 'mail'

module TackleBox
  module Email
    class Editor

      # Path to the email
      #
      # @return [String]
      attr_reader :path

      # The parsed email
      #
      # @return [Mail::Message]
      attr_reader :email

      #
      # Initializes the email editor.
      #
      # @param [String] path
      #   The path to the email.
      #
      def initialize(path)
        @path  = path
        @email = Mail.read(@path)

        @to   = @email.header[:to].address_list.addresses.first
        @from = @email.header[:from].address_list.addresses.first
      end

      #
      # Yields the email for modification.
      #
      # @yield [email]
      #   The given block will be passed the parsed email.
      #
      # @yieldparam [Mail::Message] email
      #   The parsed email.
      #
      def edit
        yield @email

        # force a re-parse of the modified email
        @email = Mail.read_from_string(@email.to_s)
      end

      #
      # Enumerates over each body part within the email.
      #
      # @yield [part]
      #   The given block will be passed each body party.
      #
      # @yieldparam [Mail::Message, Mail::Part] part
      #   A body part from the email. If the email only has a single body
      #   part, the entire `Mail::Mesage` will be yielded.
      #
      def edit_body_parts(&block)
        return enum_for(__method__) unless block_given?

        edit do |email|
          unless email.parts.empty? then email.parts.each(&block)
          else                           yield email
          end
        end
      end

      #
      # De-`quote-printable`s the email.
      #
      def dequote
        edit_body_parts do |part|
          if part.content_transfer_encoding == 'quoted-printable'
            part.content_transfer_encoding = '7bit'
            part.body = part.decoded
          end
        end
      end

      #
      # Performs global find and replace on the email.
      #
      # @param [Regexp, String] pattern
      #   The pattern to replace.
      #
      # @param [String, nil] substitute
      #   The substitute data.
      #
      # @yield [match]
      #   If a block is given, then it will be used to transform the matched
      #   data.
      #
      # @yieldparam [MatchData] match
      #   The match data.
      #
      def replace(pattern,substitute=nil,&block)
        gsub = lambda { |str|
          str.gsub(pattern,substitute,&block)
        }

        edit do |email|
          email.header = gsub.call(email.header.raw_source)
        end

        edit_body_parts do |part|
          part.body = gsub.call(part.body.decoded)
        end
      end

      #
      # Replaces the old name with a new name.
      #
      # @param [String] old_name
      #   The old name to replace.
      #
      # @param [String] new_name
      #   The new name to replace with.
      #
      def replace_name(old_name,new_name)
        old_first_name, old_last_name = old_name.split(' ',2)
        new_first_name, new_last_name = new_name.split(' ',2)

        replace(old_name,new_name)
        replace(old_last_name,new_last_name)
        replace(old_first_name,new_first_name)
      end

      #
      # Replaces all `From:` addresses globally.
      #
      # @param [String] new_from
      #   The new `From:` address.
      #
      def replace_from(new_from='{{ from.address }}')
        replace(@from.address,new_from)
      end

      #
      # Replaces the name in the `From:` header globally.
      #
      # @param [String] new_name
      #   The new name to use.
      #
      def replace_from_name(new_name=nil)
        if @from.display_name
          if new_name
            replace_name(@from.display_name,new_name)
          else
            replace(@from.display_name,'{{ from.name }}')
          end
        end
      end

      #
      # Replaces the `To:` address globally.
      #
      # @param [String] new_addr
      #   The new `To:` address to use.
      #
      def replace_to(new_addr='{{ to.address }}')
        replace(@to.address,new_addr)
      end

      #
      # Replaces the name in the `To:` address globally.
      #
      # @param [String] new_name
      #   The new name to use.
      #
      def replace_to_name(new_name=nil)
        if @to.display_name
          if new_name
            replace_name(@to.display_name,new_name)
          else
            replace(@to.display_name,'{{ to.name }}')
          end
        end
      end

      #
      # Replaces the domain globally.
      #
      # @param [String] domain
      #   The domain to replace.
      #
      # @param [String] new_domain
      #   The new domain to use.
      #
      def replace_domain(domain,new_domain='{{ link.host }}')
        replace(domain,new_domain)
      end

      #
      # Dumps out the edited email.
      #
      # @return [String]
      #   The raw email.
      #
      def to_s
        @email.to_s
      end

      #
      # Saves the edited email.
      #
      def save
        File.write(@path,@email)
      end

    end
  end
end

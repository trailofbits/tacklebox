require 'tackle_box/organization'
require 'tackle_box/email/template'
require 'tackle_box/link'
require 'tackle_box/attachment'

require 'chars'
require 'mail'

module TackleBox
  class Campaign

    # Headers for common email mailers
    HEADERS = {
      'outlook'     => {'X-Mailer' => 'Microsoft Office Outlook, Build 12.0.4210'},
      'apple_mail'  => {'X-Mailer' => 'Apple Mail (2.1498)'},
      'thunderbird' => {'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1'}
    }

    # Default domain to use for additional resources
    DEFAULT_DOMAIN = 'apt.trailofbits.com'

    # The organization that's being targetted.
    #
    # @return [Organization]
    attr_reader :organization

    # The email template to use.
    #
    # @return [Email::Template]
    attr_reader :email_template

    # The link to send.
    #
    # @return [Link]
    attr_reader :link

    # The attachment to send.
    #
    # @return [Attachment]
    attr_reader :attachment

    # The accounts to send emails from.
    #
    # @return [Array<Person>]
    attr_reader :accounts

    # Intended recipients of the campaign.
    # 
    # @return [Array<Person>]
    attr_reader :recipients

    # Mapping of identification tokens back to recipients.
    #
    # @return [Hash{String => Person}]
    attr_reader :tokens

    #
    # Initializes the campaign.
    #
    # @param [Email::Template] email_template
    #   The email template to render.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [String, URI::HTTP] :link
    #   The link to use.
    #
    # @option options [Hash] :attachment
    #   The attachment to embed. See {Attachment#initialize} for options.
    #
    # @option options [Person] :account
    #   The account that emails will be sent from.
    #
    # @option options [Array<Person>] :accounts
    #   The accounts to send emails from.
    #
    # @option options [Array<Person>] :recipients
    #   The intended recipients of the campaign.
    #
    # @option options [String] :department
    #   Targets all people in the organization's department.
    #
    # @option options [String] :location
    #   Targets all people in the given location.
    #
    # @raise [ArgumentError]
    #   The email template requires a `:accounts`, `:link` or `:attachment`
    #   option.
    #
    def initialize(email_template,organization,options={})
      @organization   = organization
      @email_template = email_template

      @mailer = options[:mailer]

      if options[:link]
        @link = Link.new(options[:link])
      elsif @email_template.requires_link?
        raise(ArgumentError,"email template requires a link")
      end

      if options[:tracking_pixel]
        @tracking_pixel = options[:tracking_pixel]
      end

      if options[:attachment]
        @attachment = Attachment.new(options[:attachment])
      elsif @email_template.requires_attachment?
        raise(ArgumentError,"email template requires an attachment")
      end

      @recipients = if options[:recipients]
                      options[:recipients]
                    elsif options[:department]
                      organization.people_in_department(options[:department])
                    elsif options[:location]
                      organization.people_from_location(options[:location])
                    else
                      organization.people
                    end

      @accounts = []

      if options[:account]
        @accounts << options[:account]
      elsif options[:accounts]
        @accounts += options[:accounts]
      elsif @email_template.requires_from?
        raise(ArgumentError,"email template requires at least one account")
      end

      @tokens = {}

      @recipients.each do |recipient|
        @tokens[new_token] = recipient
      end
    end

    #
    # Lookups the token for the given recipient.
    #
    # @param [Recipient] recipient
    #   The recipient to search for.
    #
    # @return [String, nil]
    #   The token for the recipient.
    #
    def token_for(recipient)
      token, _ = @tokens.find do |token,recipient|
        recipient == recipient
      end

      return token
    end

    #
    # Generates emails for each recipient.
    #
    # @yield [email]
    #   The given block will be passed each new message.
    #
    # @yieldparam [Mail::Message] email
    #   A newly generated email message.
    #
    def each_email
      return enum_for(__method__) unless block_given?

      @recipients.each do |recipient|
        yield email(recipient,token_for(recipient))
      end
    end

    #
    # Generates an email.
    #
    # @param [Person] to
    #   The person sending the email.
    #
    # @param [String] token
    #   Unique token to identify the recipient with.
    #
    # @param [Person] from
    #   The account to send the email from.
    #
    # @return [Mail::Message]
    #   The newly generated email.
    #
    # @raise [RuntimeError]
    #   No sending account was given.
    #
    def email(to,token,from=@accounts.sample)
      unless from
        raise(ArgumentError,"no sending account given")
      end

      variables = to_liquid.merge(
        'to'    => to.to_liquid,
        'from'  => from.to_liquid,
        'token' => token
      )

      email = @email_template.render(variables)

      if @attachment
        email.add_file(
          filename: @attachment.name,
          content:  @attachment.content
        )
      end

      return email
    end

    #
    # Converts the campaign to a liquid hash.
    #
    # @return [Hash{String => Hash}]
    #   The liquid hash containing:
    #
    #   * `organization`
    #   * `link`
    #   * `attachment`
    #
    def to_liquid
      {
        'organization' => @organization.to_liquid,
        'link'         => (@link.to_liquid if @link),
        'attachment'   => (@attachment.to_liquid if @attachment)
      }
    end

    private

    def new_token
      Chars::ALPHA_NUMERIC.random_string(12)
    end

  end
end

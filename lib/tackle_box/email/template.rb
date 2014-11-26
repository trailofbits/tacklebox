require 'tackle_box/email/template/extensions'
require 'tackle_box/email/template/filters'
require 'tackle_box/email/template/tags'

require 'mail'
require 'liquid'
require 'nokogiri'

module TackleBox
  module Email
    class Template

      # The email to be rendered.
      #
      # @return [String]
      attr_reader :email

      #
      # Initializes the email template.
      #
      # @param [String] email
      #   The raw email to render.
      #
      def initialize(email)
        @email = email
      end

      #
      # Loads an email template from a file.
      #
      # @param [String] path
      #   Path to the `.eml` file.
      #
      # @return [Template]
      #   The loaded template.
      #
      def self.open(path)
        new(File.read(path))
      end

      #
      # Determines if the email template requires the `to` variable.
      #
      # @return [Boolean]
      #   Specifies whether the email template uses the `to` variable.
      #
      def requires_to?
        @email.include?('{{ to.')
      end

      #
      # Determines if the email template requires the `from` variable.
      #
      # @return [Boolean]
      #   Specifies whether the email template uses the `from` variable.
      #
      def requires_from?
        @email.include?('{{ from.')
      end

      #
      # Determines if the email template requires the `link` variable.
      #
      # @return [Boolean]
      #   Specifies whether the email template uses the `link` variable.
      #
      def requires_link?
        @email.include?('{% link %}') ||
          @email.include?('{{ link.')
      end

      #
      # Determines if the email template requires the `attachment` variable.
      #
      # @return [Boolean]
      #   Specifies whether the email template uses the `attachment` variable.
      #
      def requires_attachment?
        @email.include?('{% attachment %}') ||
          @email.include?('{{ attachment.')
      end

      #
      # Renders the given liquid text.
      #
      # @param [String] text
      #   The text containing liquid tags.
      #
      # @param [Hash{String => String,Array,Hash}] variables
      #   Liquid template variables.
      #
      # @return [String]
      #   The rendered text.
      #
      def render_liquid(text,variables)
        liquid = Liquid::Template.parse(text)
        liquid.render(variables)
      end

      #
      # Renders the email.
      #
      # @param [Hash{String => String,Array,Hash}] variables
      #   Liquid template variables.
      #
      # @return [String]
      #   The rendered email.
      #
      def render(variables)
        new_email = Mail.read_from_string(@email)
        new_email.header = render_liquid(new_email.header.raw_source,variables)

        render_and_replace = lambda { |part|
          # only render text/plain and text/html parts
          if part.content_type =~ %r{^text/(plain|html)}
            part.body = render_liquid(part.body.decoded,variables)
          end
        }

        unless new_email.body.parts.empty?
          new_email.body.parts.each(&render_and_replace)
        else
          render_and_replace.call(new_email)
        end

        return new_email
      end

    end
  end
end

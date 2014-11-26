require 'mail'
require 'nokogiri'
require 'uri'

module TackleBox
  module Email
    module Cloner

      # The link tag to replace all links with
      LINK_TAG = '{% link %}'

      #
      # Clones the email.
      #
      # @param [String] email
      #   The raw email message.
      #
      # @param [Hash] attributes
      #   Additional attributes for the new email template.
      #
      # @return [EmailTemplate]
      #   The new email template.
      #
      def self.clone(email,attributes={})
        email = Mail.read_from_string(email)

        html = email.parts.find { |part| part.mime_type == 'text/html' }
        text = email.parts.find { |part| part.mime_type == 'text/plain' }

        body = if    html then rewrite_html(html.decoded)
               elsif text then rewrite_text(text.decoded)
               else            rewrite_text(email.body.decoded)
               end

        return EmailTemplate.new(attributes.merge(
          subject: email.subject,
          body:    body
        ))
      end

      #
      # Rewrites the HTML replacing every `a` link with the `{% link %}` tag.
      #
      # @param [String] html
      #   The raw HTML to rewrite.
      #
      # @return [String]
      #   The rewritten HTML.
      #
      def self.rewrite_html(html)
        doc  = Nokogiri::HTML(html)
        body = doc.at('//body')

        place_holder = 'LINK_GOES_HERE'

        body.search('//a/@href').each do |href|
          href.value = place_holder
        end

        html = body.inner_html
        html.strip!
        html.gsub!(place_holder,LINK_TAG)

        return html
      end

      #
      # Rewrites the text replacing every URL with the `{% link %}` tag.
      #
      # @param [String] text
      #   The raw text.
      #
      # @return [String]
      #   The rewritten text.
      #
      def self.rewrite_text(text)
        links = URI.extract(text,['http', 'https']).uniq

        links.each do |link|
          text.gsub!(link,LINK_TAG)
        end

        return text
      end

    end
  end
end

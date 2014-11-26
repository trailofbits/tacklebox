require 'liquid'
require 'uri'
require 'shorturl'

module TackleBox
  module Email
    class Template
      module Tags
        class Link < Liquid::Tag

          TOKEN_PARAM = 'token'

          def render(context)
            if (link = context['link'])

              url = URI::HTTP.build(
                host:  link['host'],
                port:  link['port'],
                path:  link['path'],
                query: link['query']
              )

              param = "#{TOKEN_PARAM}=#{context['token']}"

              if (url.query.nil? || url.query.empty?)
                url.query = param
              else
                url.query << "&#{param}"
              end

              if context['link_shortener']
                url = ShortURL.shorten(url.to_s,context['link_shortener'].to_sym)
              end

              return url
            end
          end

        end
      end
    end
  end
end

Liquid::Template.register_tag('link', TackleBox::Email::Template::Tags::Link)

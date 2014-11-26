require 'liquid'

module TackleBox
  module Email
    class Template
      module Tags
        class Attachment < Liquid::Tag

          TEXT = [
            'password:',
            'pass:',
            'passwd:',
            'the password is'
          ]

          def render(context)
            if (attachment = context['attachment'])
              text = attachment['name'].dup

              if attachment['password']
                text << " (#{TEXT.sample} #{attachment['password']})"
              end

              return text
            end
          end

        end
      end
    end
  end
end

Liquid::Template.register_tag('attachment', TackleBox::Email::Template::Tags::Attachment)

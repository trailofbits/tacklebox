require 'liquid'
require 'date'

module TackleBox
  module Email
    class Template
      module Tags
        class Date < Liquid::Tag

          def render(context)
            ::Date.today.strftime("%b %e")
          end

        end
      end
    end
  end
end

Liquid::Template.register_tag('date', TackleBox::Email::Template::Tags::Date)

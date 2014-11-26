require 'liquid'
require 'date'

module TackleBox
  module Email
    class Template
      module Tags
        class WeekDay < Liquid::Tag

          def render(context)
            ::Date.today.strftime("%A")
          end

        end
      end
    end
  end
end

Liquid::Template.register_tag('week_day', TackleBox::Email::Template::Tags::WeekDay)

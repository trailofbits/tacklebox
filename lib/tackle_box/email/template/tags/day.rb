require 'liquid'
require 'date'

module TackleBox
  module Email
    class Template
      module Tags
        class Day < Liquid::Tag

          def render(context)
            ::Date.today.strftime("%e").strip
          end

        end
      end
    end
  end
end

Liquid::Template.register_tag('day', TackleBox::Email::Template::Tags::Day)

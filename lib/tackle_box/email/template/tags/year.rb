require 'liquid'
require 'date'

module TackleBox
  module Email
    class Template
      module Tags
        class Year < Liquid::Tag

          def render(context)
            ::Date.today.year.to_s
          end

        end
      end
    end
  end
end

Liquid::Template.register_tag('year', TackleBox::Email::Template::Tags::Year)

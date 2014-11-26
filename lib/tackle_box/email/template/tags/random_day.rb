require 'liquid'

module TackleBox
  module Email
    class Template
      module Tags
        class RandomDay < Liquid::Tag

          def render(context)
            rand(Date.today.day - 1) + 1
          end

        end
      end
    end
  end
end

Liquid::Template.register_tag('random_day', TackleBox::Email::Template::Tags::RandomDay)

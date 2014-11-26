require 'liquid'

module TackleBox
  module Email
    class Template
      module Tags
        class RandomDate < Liquid::Tag

          def render(context)
            today = Date.today

            return today.strftime("%b #{rand(today.day - 1) + 1}")
          end

        end
      end
    end
  end
end

Liquid::Template.register_tag('random_date', TackleBox::Email::Template::Tags::RandomDate)

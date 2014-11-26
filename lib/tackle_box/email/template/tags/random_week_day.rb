require 'liquid'

module TackleBox
  module Email
    class Template
      module Tags
        class RandomWeekDay < Liquid::Tag

          DAYS = %w[Monday Tuesday Wednesday Thursday Friday]

          def render(context)
            DAYS.sample
          end

        end
      end
    end
  end
end

Liquid::Template.register_tag('random_week_day', TackleBox::Email::Template::Tags::RandomWeekDay)

require 'liquid'

module TackleBox
  module Email
    class Template
      module Tags
        class RandomGreeting < Liquid::Tag

          GREETINGS = [
            'Good day',
            'How are you doing',
            'I hope everything is well with you',
            'Dear',
            'Hello'
          ]

          def render(context)
            GREETINGS.sample
          end

        end
      end
    end
  end
end

Liquid::Template.register_tag('random_greeting', TackleBox::Email::Template::Tags::RandomGreeting)

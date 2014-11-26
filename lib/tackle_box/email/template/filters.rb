require 'liquid'

require 'active_support/inflector'

module TackleBox
  module Email
    class Template
      module Filters
        #
        # Converts the input to all lower-case.
        #
        # @param [String] input
        #   The input.
        #
        # @return [String]
        #   The lower-cased output.
        #
        def lowercase(input)
          input.downcase
        end

        #
        # Converts the input to all upper-case.
        #
        # @param [String] input
        #   The input.
        #
        # @return [String]
        #   The upper-cased output.
        #
        def uppercase(input)
          input.upcase
        end

        #
        # Capitalizes the first character of the input.
        #
        # @param [String] input
        #   The input.
        #
        # @return [String]
        #   The capitalized output.
        #
        def capitalize(input)
          input.capitalize
        end

        #
        # Pluralizes the input.
        #
        # @param [String] input
        #   The input.
        #
        # @return [String]
        #   The pluralized output.
        #
        def pluralize(input)
          ActiveSupport::Inflector.pluralize(input)
        end

        #
        # Singularizes the input.
        #
        # @param [String] input
        #   The input.
        #
        # @return [String]
        #   The singularized output.
        #
        def singularize(input)
          ActiveSupport::Inflector.singularize(input)
        end
      end
    end
  end
end

Liquid::Template.register_filter(TackleBox::Email::Template::Filters)

module Patme
  module Arguments
    class Specific
      def initialize(value)
        @value = value
      end

      def get_value(given)
        given
      end

      def ==(other)
        @value.is_a?(Class) ? other.is_a?(@value) : @value == other
      end

      def any?; false; end
      def optional?; false; end
      def specific?; true; end
    end
  end
end

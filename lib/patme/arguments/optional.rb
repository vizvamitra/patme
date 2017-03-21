module Patme
  module Arguments
    class Optional
      def initialize(default_value)
        @default_value = default_value
      end

      # *given is an array to distinguish cases with no value or nil
      def get_value(*given)
        given.size == 1 ? given.first : @default_value
      end

      def ==(other)
        true
      end

      def any?; false; end
      def optional?; true; end
      def specific?; false; end
    end
  end
end

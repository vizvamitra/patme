module Patme
  module Arguments
    class Arbitrary
      def initialize(_value=nil)
      end

      def get_value(given=nil)
        given
      end

      def ==(other)
        true
      end

      def any?; true; end
      def optional?; false; end
      def specific?; false; end
    end
  end
end

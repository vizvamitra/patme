module Patme
  class Method

    def initialize(name)
      @name = name
      @implementations = []
    end

    def add_implementation(implementation)
      @implementations << implementation
    end

    def implemented_for?(args)
      @implementations.any?{|i| i.match?(args)}
    end

    def call(object, args)
      @implementations.find{|i| i.match?(args)}.call(object, args)
    end

  end
end

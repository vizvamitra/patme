module Patme
  class Implementation

    def initialize(method_obj, args)
      @method_proc = method_obj
      @args = args
    end

    def match?(given_args)
      required_args = @args.reject(&:optional?)

      (required_args.size..@args.size).cover?(given_args.size)\
        && required_args == given_args.first(required_args.size)
    end

    def call(object, args)
      @method_proc.bind(object).call(*args)
    end

  end
end

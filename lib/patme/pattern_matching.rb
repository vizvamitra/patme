module Patme

  module PatternMatching
    def self.included(klass)
      klass.include(InstanceMethods)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def method_added(name)
        @patme_methods ||= {}
        @patme_methods[name] ||= Patme::Method.new(name)

        method_obj = self.instance_method(name)
        impl = Patme::ImplementationBuilder.new(method_obj).build
        @patme_methods[name].add_implementation(impl)

        undef_method(name)
      end

      def patme_method(name)
        @patme_methods[name]
      end
    end

    module InstanceMethods
      def method_missing name, *args, &block
        method = self.class.patme_method(name)
        if method && method.implemented_for?(args)
          method.call(self, args)
        else
          super
        end
      end
    end
  end

end

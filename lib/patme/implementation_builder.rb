module Patme

  # Parses method's arguments and creates method implementation.
  #
  # For example, if method looks like this:
  #
  # def foo(arg1, arg2='foo', _arg3='bar')
  #   # some code
  # end
  #
  # then implementation will be created with the following arguments:
  #    arg1 - arbitrary argument
  #    arg2 - specific argument, 'foo'
  #   _arg3 - optional argument, defaults to 'bar'
  class ImplementationBuilder
    def initialize(method_obj)
      @method_obj = method_obj
    end

    def build
      Patme::Implementation.new(@method_obj, arguments)
    end

    private

    def arguments
      method_ast = Parser::CurrentRuby.parse(@method_obj.source)
      arguments_ast = method_ast.children[1].children

      arguments_ast.map{|arg_ast| build_argument(arg_ast)}
    end

    def build_argument(ast_node)
      name = ast_node.children[0]
      type = ast_node.type

      case type
      when :optarg
        default_value = eval ast_node.children[1].location.expression.source
        arg_class = name[0] == '_' ? Arguments::Optional : Arguments::Specific
        arg_class.new(default_value)
      when :arg
        Arguments::Arbitrary.new
      else
        raise "Argument #{name} has unsupported argument type: #{type}"
      end
    end
  end

end

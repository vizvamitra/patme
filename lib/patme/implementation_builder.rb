module Patme

  # Gets method's header (for example, def foo(arg1, arg2='spec', _arg3='opt') )
  # parses it and creates method implementation with the following arguments:
  #    arg1 - any argument
  #    arg2 - specific argument, 'spec'
  #   _arg3 - optional argument which defaults to 'opt'
  class ImplementationBuilder
    def initialize(method_obj)
      @method_obj = method_obj
    end

    def build
      values = get_values(method_header, method_params)
      args = build_args(method_params, values)

      Patme::Implementation.new(@method_obj, args)
    end

    private

    def get_values(header, params)
      return {} if params.size == 0

      regex_str = params.map do |type, name|
        case type
        when :opt then "#{name}=(?<#{name}>.+)"
        when :req
          name =~ /^_/ ? "#{name}=(?<#{name}>.+)" : "#{name}"
        end
      end.join(', ') + '\s*\)\s*$'

      match_data = header.match( Regexp.new(regex_str) )
      match_data.names.map do |name|
        [name.to_sym, eval(match_data[name.to_s])]
      end.to_h
    end

    def method_header
      path, line = @method_obj.source_location
      File.read(path).split("\n")[line - 1]
    end

    def method_params
      @method_obj.parameters
    end

    def build_args(params, values)
      return [] if params.size == 0

      params.map do |type, name|
        case type
        when :opt
          (name =~ /^_/ ? Arguments::Optional : Arguments::Specific).new(values[name])
        when :req then Arguments::Arbitrary.new
        end
      end
    end
  end

end

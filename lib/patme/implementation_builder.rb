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
      Patme::Implementation.new(@method_obj, build_args)
    end

    private

    def get_values
      return {} if method_params.empty?
      return @_values if @_values

      regex_str = method_params.map do |type, name|
        case type
        when :opt then "#{name}=(?<#{name}>.+)"
        when :req
          name[0] == '_' ? "#{name}=(?<#{name}>.+)" : "#{name}"
        end
      end.join(', ') + '\s*\)\s*$'

      match_data = method_header.match( Regexp.new(regex_str) )
      @_values = match_data.names.map do |name|
        [name.to_sym, eval(match_data[name.to_s])]
      end.to_h
    end

    def method_header
      path, line = @method_obj.source_location
      File.read(path).lines.take(line).last
    end

    def method_params
      @method_obj.parameters
    end

    def build_args
      return [] if method_params.empty?

      method_params.map do |type, name|
        case type
        when :opt
          (name[0] == '_' ? Arguments::Optional : Arguments::Specific).new(get_values[name])
        when :req then Arguments::Arbitrary.new
        end
      end
    end
  end

end

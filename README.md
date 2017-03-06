# Patme

[![Build Status](https://travis-ci.org/vizvamitra/patme.svg?branch=master)](https://travis-ci.org/vizvamitra/patme)

This gem is my experiment on elixir-style pattern matching in ruby.

The implementation is neither production-ready, nor complete. It is just a proof of concept.

## Info

Patme module stores your instance methods internally and removes them from your class. Then, when method is called, it tries to pattern-match given arguments with existing method implementations. If implementation was found, it executes it, othervise you'll get a NoMethodError.

Currently this gem supports 3 types of arguments: specific, arbitrary and optional. In method definition `def foo(agr1, arg2=1, _arg3=false)` arg1 is an arbitrary argument, arg2 is specific and arg3 is optional.

Patme supports class-based pattern matching. If method's specific argument is a `Class`, then it will be matched based on given argument's class using `is_a?`


## Limitations

Only pattern matching on instance methods is supported. Also you must use parentheses around method arguments.


## Usage

#### Recursion example

```ruby
require 'patme'

class Factorial
  include Patme::PatternMatching

  def calculate(n=0)
    1
  end

  def calculate(n)
    n * self.of(n-1)
  end
end

factorial_calculator = Factorial.new

factorial_calculator.calculate(0) # => 1
factorial_calculator.calculate(5) # => 120
factorial_calculator.calculate(-1) # => endless recursion, don't do so ^_^
```


#### Class-based pattern matching

```ruby
require 'parme'

SeriousError = Class.new(StandardError)
RegularError = Class.new(StandardError)
UnexpectedError = Class.new(StandardError)

class ErrorHandler
  include Patme::PatternMatching

  def initialize(error)
    @error = error
  end

  def handle
    do_handle(@error)
  end

  # Will match if error.is_a?(SeriousError)
  def do_handle(error=SeriousError)
    puts "Alarm! SeriousError! Details: #{error.message}"
  end

  # Will match if error.is_a?(RegularError)
  def do_handle(error=RegularError)
    puts "Don't worry, just a RegularError: #{error.message}"
  end

  # Will match for all other StandardErrors
  def do_handle(error=StandardError)
    puts "Unexpected error: #{error.class}. Details: #{error.message}"
  end
end

begin
  raise SeriousError, 'boom!'
rescue => error
  ErrorHandler.new(error).handle
end
# => Alarm! SeriousError! Details: boom!

begin
  raise RegularError, 'we need to fix this'
rescue => error
  ErrorHandler.new(error).handle
end
# => Don't worry, just a RegularError: we need to fix this

begin
  raise UnexpectedError, 'something went completely wrong'
rescue => error
  ErrorHandler.new(error).handle
end
# => Unexpected error: UnexpectedError. Details: something went completely wrong
```


#### Full-featured example

```ruby
require 'patme'

class MyClass
  include Patme::PatternMatching

  # This method will match only when arg1  ='test'
  def foo(arg1='test')
    "runned foo('test') with #{arg1}"
  end

  # Will match only when arg1  ='other'
  def foo(arg1='other')
    "runned foo('other') with #{arg1}"
  end

  # You can also use other basic types
  def foo(arg1={a: 1, b: 2})
    "runned foo({a: 1, b: 2}) with #{arg1}"
  end

  # Will match when arg2 = 'test' no matter what arg1 is
  def foo(arg1, arg2='test')
    "runned foo(any, 'test') with [#{arg1}, #{arg2}]"
  end

  # Will match with any arg1 and both with and without arg2
  # if arg2 is not supplied, method will receive arg2 = 'default'
  def foo(arg1, _arg2="default")
    "runned foo(any, optional) with [#{arg1}, #{_arg2}]"
  end


  # Will match with any one argument.
  def bar(arg1)
    "runned bar(any) with #{arg1}"
  end

  # Won't ever match because previous definition of bar will be pattern-matched
  # before this one
  def bar(arg1='never')
    "runned bar('never') with #{arg1}"
  end


  def baz(arg1='test')
    "runned baz('test') with #{arg1}"
  end
end

my_obj = MyClass.new

my_obj.foo('test') # => "runned foo('test') with test"
my_obj.foo('other') # => "runned foo('other') with other"
my_obj.foo({a: 1, b: 2}) # => "runned foo({a: 1, b: 2}) with {:a => 1, :b => 2}"
my_obj.foo(1, 'test') # => "runned foo(any, 'test') with [1, test]"
my_obj.foo(1) # => "runned foo(any, optional) with [1, default]"
my_obj.foo(1, 'some') # => "runned foo(any, optional) with [1, some]"

my_obj.bar(1) # => "runned bar(any) with 1"
my_obj.bar('never') # => "runned bar(any) with never"

my_obj.baz('test') # => "runned baz('test') with test"
my_obj.baz(1) # => NoMethodError
```


## Todos

1. Add support for keyword arguments (`key:` - arbitrary, `key: value` - specific, `_key: value` - optional)
2. Add support for class methods
3. Add something to tell Parme not to pattern-match on given methods

    ```ruby
    # Possible example
    class Hello
      include Parme::PatternMatching

      # Comment after method header will tell Parme not to touch this method
      def tell(name) # ::pm_off
        puts "Hello, #{name}"
      end
    end
    ```

4. Add support for method headers without parentheses
5. Add watchers

    ```ruby
    # Possible example
    class Factorial
      include Patme::PatternMatch

      def calculate(n=0)
        1
      end

      def calculate(n) # ::when( n < 0 )
        raise ArgumentError, "Can't calculate factorial of a negative number: #{n}"
      end

      def calculate(n) # ::when( n > 0 )
        n * self.of(n-1)
      end
    end
    ```

6. Your suggestions?


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vizvamitra/patme.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


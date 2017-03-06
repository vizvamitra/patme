require 'spec_helper'

class Factorial
  include Patme::PatternMatching

  def calculate(n=0)
    1
  end

  def calculate(n)
    n * calculate(n-1)
  end
end

describe Factorial do
  subject{ described_class.new }

  it 'calculates factorial of 0 correctly' do
    expect( subject.calculate(0) ).to eq 1
  end

  it 'calculates factorial of 5 correctly' do
    expect( subject.calculate(5) ).to eq 120
  end
end

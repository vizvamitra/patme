require 'spec_helper'

class Factorial
  include Patme::PatternMatching

  def of(n=0)
    1
  end

  def of(n)
    n * self.of(n-1)
  end
end

describe Factorial do
  subject{ described_class.new }

  it 'counts factorial of 0 correctly' do
    expect( subject.of(0) ).to eq 1
  end

  it 'counts factorial of 5 correctly' do
    expect( subject.of(5) ).to eq 120
  end
end

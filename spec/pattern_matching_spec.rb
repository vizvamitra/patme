require "spec_helper"

class DummyPatternMatchable
  include Patme::PatternMatching

  def foo(arg1='test')
    ["foo('test')", arg1]
  end

  def foo(arg1=1)
    ["foo(1)", arg1]
  end

  def foo(arg1={a: 1})
    ['foo({a: 1})', arg1]
  end

  def foo(arg1=true)
    ['foo(true)', arg1]
  end

  def foo()
    'foo()'
  end

  def foo(any)
    ["foo(any)", any]
  end

  def bar(arg1='bar', arg2='test')
    ["bar('bar', 'test')", [arg1, arg2]]
  end

  def bar(arg1='first', _arg2='opt')
    ["bar('first', optional)", [arg1, _arg2]]
  end

  def bar(any, arg2="test")
    ["bar(any, 'test')", [any, arg2]]
  end

  def bar(any, _arg2="opt")
    ["bar(any, optional)", [any, _arg2]]
  end

  def baz(arg1='test')
    ["baz('test')", arg1]
  end

  # don't work yet

  # def foo(bar: "test")
  #   "foo(bar: 'test')"
  # end
end

RSpec.describe DummyPatternMatchable do
  subject{ described_class.new }

  it "correctly runs foo('test')" do
    expect( subject.foo('test') ).to eq ["foo('test')", 'test']
  end

  it "correctly runs foo(1)" do
    expect( subject.foo(1) ).to eq ["foo(1)", 1]
  end

  it "correctly runs foo({a: 1})" do
    expect( subject.foo({a: 1}) ).to eq ["foo({a: 1})", {a: 1}]
  end

  it "correctly runs foo(true)" do
    expect( subject.foo(true) ).to eq ["foo(true)", true]
  end

  it "correctly runs foo(any)" do
    expect( subject.foo(:any)  ).to eq ["foo(any)", :any]
    expect( subject.foo('any') ).to eq ["foo(any)", 'any']
    expect( subject.foo({})    ).to eq ["foo(any)", {}]
  end

  it "correctly runs foo()" do
    expect( subject.foo ).to eq "foo()"
  end

  it "correctly runs bar('bar', 'test')" do
    expect( subject.bar('bar', 'test') ).to eq ["bar('bar', 'test')", ['bar', 'test']]
  end

  it "correctly runs bar('first', optional)" do
    expect( subject.bar('first')  ).to eq ["bar('first', optional)", ['first', 'opt']]
    expect( subject.bar('first', 'test') ).to eq ["bar('first', optional)", ['first', 'test']]
  end

  it "correctly runs bar(any, 'test')" do
    expect( subject.bar(:any, 'test')  ).to eq ["bar(any, 'test')", [:any, 'test']]
    expect( subject.bar('any', 'test') ).to eq ["bar(any, 'test')", ['any', 'test']]
  end

  it "correctly runs bar(any, optional)" do
    expect( subject.bar(:any)          ).to eq ["bar(any, optional)", [:any,  'opt']]
    expect( subject.bar('any')         ).to eq ["bar(any, optional)", ['any', 'opt']]
    expect( subject.bar(:any, 'some')  ).to eq ["bar(any, optional)", [:any,  'some']]
    expect( subject.bar('any', 'some') ).to eq ["bar(any, optional)", ['any', 'some']]
  end

  it "correctly runs baz('test')" do
    expect( subject.baz('test') ).to eq ["baz('test')", 'test']
  end

  it "raises NoMethodError when baz is ran with unknown arguments" do
    expect{ subject.baz(1) }.to raise_error(NoMethodError)
  end
end

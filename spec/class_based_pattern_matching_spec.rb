require "spec_helper"

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

  def do_handle(error=SeriousError)
    ["do_handle(SeriousError)", error.message]
  end

  def do_handle(error=RegularError)
    ["do_handle(RegularError)", error.message]
  end

  def do_handle(error=StandardError)
    ["do_handle(StandardError)", error.message]
  end
end

describe ErrorHandler do
  subject{ described_class.new(error).handle }

  context 'when instance of SeriousError is given' do
    let(:error){ SeriousError.new('boom!') }
    it{ is_expected.to eq ["do_handle(SeriousError)", "boom!"] }
  end

  context 'when instance of RegularError is given' do
    let(:error){ RegularError.new('again') }
    it{ is_expected.to eq ["do_handle(RegularError)", "again"] }
  end

  context 'when instance of UnexpectedError is given' do
    let(:error){ UnexpectedError.new('oops') }
    it{ is_expected.to eq ["do_handle(StandardError)", "oops"] }
  end
end

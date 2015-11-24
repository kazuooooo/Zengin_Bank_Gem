require 'spec_helper'
require 'bank'

RSpec.describe Bank do
  it 'return Enumerator' do
    bank = Bank.new(1, "testbank")
    expect(bank.branches).to be_kind_of(Enumerator)
  end
end

require_relative 'spec_helper'
require_relative '../lib/bank.rb'

RSpec.describe Bank do
  describe "#branches" do
    context '紀央銀行' do
      let(:bank){ Bank.new("0163", "紀陽銀行") }

      it 'return Enumerator' do
        expect(bank.branches).to be_kind_of(Enumerator)
      end

      it 'no overlaps' do
        expect(bank.branches.to_a.uniq.length).to eq(bank.branches.to_a.length)
      end

      it 'match the correct amount' do
        expect(bank.branches.to_a.length).to eq(109)
      end
    end
  end
end
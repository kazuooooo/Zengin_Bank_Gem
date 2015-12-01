require_relative 'spec_helper'
require_relative '../lib/bank.rb'

RSpec.describe Bank do
  describe "#branches" do
    context '紀央銀行' do
      let(:bank){ Bank.new("0163", "紀央銀行") }

      it 'return Enumerator' do
        p bank.branches
        expect(bank.branches).to be_kind_of(Enumerator)
      end
      describe "#branches.each"
        it '重複がない' do
          expect(bank.branches.to_a.uniq.length).to eq(bank.branches.to_a.length)
        end

        it 'ある支店を含んでいる' do
          expect(bank.branches.to_a.length).to eq(109)
        end

        it 'ある支店の支店名と支店コードが一致する' do
        end
      end
    end
  end
end
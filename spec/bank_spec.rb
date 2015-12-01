require_relative 'spec_helper'
require_relative '../lib/bank.rb'

RSpec.describe Bank do
  
  attr_accessor :bank
  before do
    @bank = Bank.new('0001', 'みずほ銀行', 'ﾐｽﾞﾎｷﾞﾝｺｳ')
  end

  describe '#branches' do
    it 'branchesを呼んだ時にBranchCollectionが返る' do
      expect(bank.branches).to be_kind_of(Bank::BranchCollection)
    end
  end

  describe Bank::BranchCollection do
    describe 'ある取得した支店の名前とコードが正しく取得出来ている' do
      context 'みずほ銀行灘支店の場合' do
        it '支店コードは491になる' do
            branch = bank.branches.each.find do |branch|
                     branch.name == '灘支店'
                   end
            expect(branch.branch_code).to eq('491')
        end
      end
    end
  end
end
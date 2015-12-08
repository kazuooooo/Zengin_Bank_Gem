require 'vcr'
require_relative 'spec_helper'
require_relative '../lib/bank'

RSpec.describe Bank do

  attr_accessor :bank
  before do
    @bank = Zengin.banks.each.find do |bank|
              bank.bank_name == "愛知銀行"
            end
  end

  describe '#branches' do
    it 'branchesを呼んだ時にBranchCollectionが返る' do
      expect(bank.branches).to be_kind_of(Bank::BranchCollection)
    end
  end

  describe Bank::BranchCollection do
    describe 'ある取得した支店の名前とコードが正しく取得出来ている' do
      context '愛知銀行一宮支店の場合' do
        
        attr_accessor :branch
        before do
          @branch = @bank.branches.each.find do |branch|
                      branch.branch_name == '一宮支店'
                    end
        end

        it '支店コードは769になる' do
          expect(@branch.branch_code).to eq('301')
        end
        
        it 'よみがなは"ｲﾁﾉﾐﾔ"になる' do
          expect(@branch.branch_yomi).to eq('ｲﾁﾉﾐﾔ')
        end

      end
    end

    describe 'あるかなの支店が全て取得出来ている' do
      context '愛知銀行の"ほ"の場合' do
        attr_accessor :branches
        before do
          @branches = bank.branches.each.find_all do |branch|
                        branch.branch_yomi[0, 1] == 'ﾎ'
                      end
        end

        it '4つの支店がある' do
          expect(branches.length).to eq(4)
        end

        it '重複がない' do
          expect(branches.uniq.length).to eq(branches.length)
        end

        it '本店営業部を含んでいる' do
          expect(branches.each.find {|branch| branch.branch_name == '本店営業部'}.branch_name).not_to be_empty
        end

      end
    end
  end
end
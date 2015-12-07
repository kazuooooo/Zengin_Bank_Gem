require 'vcr'
require_relative 'spec_helper'
require_relative '../lib/bank'

RSpec.describe Bank, vcr: { cassette_name: 'bank_spec', :record => :new_episodes } do
  
  attr_accessor :bank
  before do
    @bank = Zengin.banks.find do |bank|
              bank.bank_name == "アイオー信用金庫"
            end
    binding.pry
  end

  describe '#branches' do
    it 'branchesを呼んだ時にBranchCollectionが返る' do
      expect(bank.branches).to be_kind_of(Bank::BranchCollection)
    end
  end

  describe Bank::BranchCollection do
    describe 'ある取得した支店の名前とコードが正しく取得出来ている' do
      context 'みずほ銀行池尻大橋支店の場合' do
        
        attr_accessor :branch
        before do
          @branch = bank.branches.each.find do |branch|
                      branch.branch_name == '池尻大橋支店'
                    end
        end

        it '支店コードは769になる' do
          expect(branch.branch_code).to eq('769')
        end
        
        it 'よみがなは"ｲｹｼﾞﾘｵｵﾊｼ"になる' do
          expect(branch.yomi).to eq('ｲｹｼﾞﾘｵｵﾊｼ')
        end

      end
    end

    describe 'あるかなの支店が全て取得出来ている' do
      context 'みずほ銀行の"ほ"の場合' do
        attr_accessor :branches
        before do
          @branches = bank.branches.each.find_all do |branch|
                        branch.yomi[0, 1] == 'ﾎ'
                      end
        end

        it '5つの支店がある' do
          expect(branches.length).to eq(5)
        end

        it '重複がない' do
          expect(branches.uniq.length).to eq(branches.length)
        end

        it '本店を含んでいる' do
          expect(branches.each.find {|branch| branch.name == '本店'}.name).not_to be_empty
        end

      end
    end
  end
end
require_relative 'spec_helper'
require_relative '../lib/zengin_bank_gem'
require_relative 'testclass'
require_relative '../lib/bank_scraper'
require 'pry'

RSpec.describe Zengin do
  attr_accessor :test_class, :banks
  before do
    @test_class = TestClass.new
    @banks = test_class.banks
  end

  describe '#banks' do
    it 'banksを呼んだ時にBankCollectionが返る' do
      expect(test_class.banks).to be_kind_of(Zengin::BankCollection)
    end
  end

  describe Zengin::BankCollection do
    describe 'ある取得した銀行の名前とコードが正しく取得出来ている' do
      context '松本信用金庫の場合' do
        it 'コードは1391になる' do
          bank = banks.each.find do |bank|
                   bank.name == '松本信用金庫'
                 end
          expect(bank.bank_code).to eq('1391')
        end
      end
    end

    describe 'あるかなの銀行が全て取得出来ている' do
      context '"の"の場合' do
        attr_accessor :no_banks
        before do
          @no_banks = banks.each.find_all do |bank|
                       bank.yomi[0, 1] == 'ﾉ'
                     end
        end

        it '9つの金融機関がある' do
          expect(no_banks.length).to eq(9)
        end

        it '重複がない' do
          expect(no_banks.uniq.length).to eq(no_banks.length)
        end

        it '延岡信用金庫を含んでいる' do
          expect(no_banks.each.find {|branch| branch.name == '延岡信用金庫'}.name).not_to be_empty
        end

      end
    end
  end
end
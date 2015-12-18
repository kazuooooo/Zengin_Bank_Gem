require 'vcr'
require_relative './spec_helper'


RSpec.describe ZenginBankGem, vcr: { cassette_name: 'zengin_spec', :record => :new_episodes } do

  attr_accessor :banks
  before do
    @banks = ZenginBankGem.banks
  end

  describe '#banks' do
    it 'banksを呼んだ時にZenginBankGem::BankCollectionが返る' do
      expect(ZenginBankGem.banks).to be_kind_of(ZenginBankGem::BankCollection)
    end
  end

  describe ZenginBankGem::BankCollection do
    describe 'ある取得した銀行の名前とコードが正しく取得出来ている' do
      context '松本信用金庫の場合' do
        it 'コードは1391になる' do
          bank = 
            banks.each.find do |bank|
              bank.bank_name == '松本信用金庫'
            end
          expect(bank.bank_code).to eq('1391')
        end
      end
    end
  end

  describe 'あるかなの銀行が全て取得出来ている' do
    context '"の"の場合' do
      attr_accessor :no_banks
      before do
        @no_banks = 
          banks.each.find_all do |bank|
            bank.bank_yomi[0, 1] == 'ﾉ'
          end
      end

      it '9つの金融機関がある' do
        expect(no_banks.length).to eq(9)
      end

      it '重複がない' do
        expect(no_banks.uniq.length).to eq(no_banks.length)
      end

      it '延岡信用金庫を含んでいる' do
        expect(no_banks.each.find {|bank| bank.bank_name == '延岡信用金庫'}.bank_name).not_to be_empty
      end

    end
  end

  VCR.use_cassette("mk_csv", :record => :new_episodes) do
    describe 'csv出力' do
      it 'csv全件出力される', full_dump: true do
        expect(ZenginBankGem.mk_csv_file('zengin_test2')).not_to be_empty
      end
    end
  end
end

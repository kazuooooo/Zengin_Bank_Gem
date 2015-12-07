require 'vcr'
require_relative './spec_helper'


#RSpec.describe Zengin, vcr: { cassette_name: 'zengin_spec', :record => :new_episodes } do
RSpec.describe Zengin do
  # attr_accessor :banks
  # before do
  #   @banks = Zengin.banks
  # end

  # describe '#banks' do
  #   it 'banksを呼んだ時にBankCollectionが返る' do
  #     expect(Zengin.banks).to be_kind_of(Zengin::BankCollection)
  #   end
  # end

  # describe Zengin::BankCollection do
  #   describe 'ある取得した銀行の名前とコードが正しく取得出来ている' do
  #     context '松本信用金庫の場合' do
  #       it 'コードは1391になる' do
  #         bank = banks.each.find do |bank|
  #                  bank.name == '松本信用金庫'
  #                end
  #         expect(bank.bank_code).to eq('1391')
  #       end
  #     end
  #   end
  # end

  # describe 'あるかなの銀行が全て取得出来ている' do
  #   context '"の"の場合' do
  #     attr_accessor :no_banks
  #     before do
  #       @no_banks = banks.each.find_all do |bank|
  #                     bank.bank_yomi[0, 1] == 'ﾉ'
  #                   end
  #     end

  #     it '9つの金融機関がある' do
  #       expect(no_banks.length).to eq(9)
  #     end

  #     it '重複がない' do
  #       expect(no_banks.uniq.length).to eq(no_banks.length)
  #     end

  #     it '延岡信用金庫を含んでいる' do
  #       expect(no_banks.each.find {|branch| branch.name == '延岡信用金庫'}.name).not_to be_empty
  #     end

  #   end
  # end

  # describe '全件出力できるかのテスト' do
  #   it 'put all' do
  #     banks.each do |bank|
  #       p bank.name
  #       bank.branches.each do |branch| 
  #         p branch.name
  #       end
  #     end
  #   end
  # end

  describe 'csv出力' do
    it 'csv全件出力される' do
      VCR.use_cassette("mk_csv", :record => :new_episodes) do
        Zengin.mk_csv_file('zengin_test')
      end
    end
  end
end
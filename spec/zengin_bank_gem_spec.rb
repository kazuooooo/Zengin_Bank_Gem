require_relative 'spec_helper'
require_relative '../lib/zengin_bank_gem.rb'
require_relative '../lib/testclass.rb'
require_relative '../lib/bank_scraper.rb'
require 'pry'

RSpec.describe Zengin do
  attr_accessor :test_class
  before do
    @test_class = TestClass.new
  end

  describe '#banks' do
    it 'banksを呼んだ時にBankCollectionが返る' do
      expect(test_class.banks).to be_kind_of(Zengin::BankCollection)
    end
  end

  describe "BankCollection" do
    describe 'ある取得した銀行の名前とコードが正しく取得出来ている' do
      context '松本信用金庫の場合' do
        it 'コードは1391になる' do
            bank = test_class.banks.each.find do |bank|
                     bank.name == '松本信用金庫'
                   end
            expect(bank.bank_code).to eq('1391')
        end
      end
    end
  end
end
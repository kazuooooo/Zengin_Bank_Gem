require_relative 'spec_helper'
require_relative '../lib/scraper.rb'
require_relative '../lib/bank_scraper.rb'

RSpec.describe BankScraper do
  
  attr_accessor :pages
  before do
    bank_scraper = BankScraper.new
    @pages = bank_scraper.get_banks_list_pages
  end

  describe '#get_banks_list_pages' do
    describe '全てのかなページを取得出来ている' do

      it 'Pageオブジェクトが返っている' do
        expect(pages.first).to be_kind_of(Mechanize::Page)
      end
      
      it '45種類ページが返っている' do
        expect(pages.length).to eq(45)
      end

      it '重複がない' do
        expect(pages.uniq.length).to eq(pages.length)
      end

    end
  end

end


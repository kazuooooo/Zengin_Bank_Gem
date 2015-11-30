require_relative 'spec_helper'
require_relative '../lib/scraper.rb'
require_relative '../lib/branch_scraper.rb'

RSpec.describe Scraper do

  describe 'get_all_kanas' do 
    subject(:scraper){ Scraper.new }
    
    it 'return 45 letters' do
      expect(scraper.get_all_kanas.length).to eq(45)
    end

    it 'include "A-Z"' do
      expect(scraper.get_all_kanas).to include("A-Z")
    end

  end

  describe '#click_kana_link' do
    context '銀行一覧ページ(引数0)' do
      before do
        scraper = Scraper.new
        agent = Mechanize.new
        agent.get('http://zengin.ajtw.net/')
        kanas = scraper.get_all_kanas
        @rand_kana = kanas[rand(kanas.length)]
        @page = scraper.click_kana_link(@rand_kana, 0)
      end

      it 'return Mechanize:Page' do
        expect(@page).to be_kind_of(Mechanize::Page)
      end

      it '銀行選択文字がランダムに取得したかな(@rand_kana)であること' do
        expect(@page.forms[1].field.value[0,1]).to eq(@rand_kana)
      end

    end

    context '支店一覧ページ(引数1)' do
      before do
        scraper = BranchScraper.new
        agent = Mechanize.new
        scraper.search_bank('0001')
        kanas = scraper.get_all_kanas
        @rand_kana = kanas[rand(kanas.length)]
        @page = scraper.click_kana_link(@rand_kana, 1)
      end

      it 'return Mechanize:Page' do
        expect(@page).to be_kind_of(Mechanize::Page)
      end

      it '支店選択文字がランダムに取得したかな(@rand_kana)であること' do
        expect(@page.forms[1].field.value[-1,1]).to eq(@rand_kana)
      end
    end
  end

end
require_relative 'spec_helper'
require_relative '../lib/scraper.rb'
require_relative '../lib/branch_scraper.rb'

RSpec.describe BranchScraper do
  
  attr_accessor :pages
  before do
    branch_scraper = BranchScraper.new
    @pages = branch_scraper.get_branch_list_pages
  end

  describe '#get_branchs_list_pages' do
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


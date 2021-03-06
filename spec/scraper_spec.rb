require_relative 'spec_helper'
require 'vcr'

RSpec.describe ZenginBankGem::Scraper do

    VCR.use_cassette("scraper_spec", :record => :new_episodes) do
      describe '#get_banks_list_pages' do
        describe '全ての銀行かなページを取得出来ている' do
          
          before do
            @bank_pages = ZenginBankGem::Scraper.instance.get_banks_list_pages
          end

          it 'Pageオブジェクトが返っている' do
            expect(@bank_pages.first).to be_kind_of(Mechanize::Page)
          end
          
          it '44種類ページが返っている' do
            expect(@bank_pages.length).to eq(44)
          end

          it '重複がない' do
            expect(@bank_pages.uniq.length).to eq(@bank_pages.length)
          end

        end
      end
    end

    VCR.use_cassette("scraper_spec_2") do
        describe '#get_branch_list_pages' do
          describe '全てのかなページを取得出来ている' do
            
            before do
              tbank = 
                ZenginBankGem.banks.each.find do |bank|
                  bank.bank_name == "愛知県警察信用組合"
                end
              @branch_pages = ZenginBankGem::Scraper.instance.get_branch_list_pages(tbank.branch_kana_page)
            end

            it 'Pageオブジェクトが返っている' do
              expect(@branch_pages.first).to be_kind_of(Mechanize::Page)
            end

            it '45種類ページが返っている' do
              expect(@branch_pages.length).to eq(45)
            end

            it '重複がない' do
              expect(@branch_pages.uniq.length).to eq(@branch_pages.length)
            end

          end
        end
    end
end

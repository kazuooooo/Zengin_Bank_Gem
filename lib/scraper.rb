require 'rubygems'
require 'nokogiri'
require 'mechanize'
require 'pry'
require_relative 'bank'

class Scraper
    attr_accessor :agent, :page
    def initialize
      @agent = Mechanize.new
      @page = ''
    end
    
    def get_all_banks
      kanas = get_all_kanas
      banks = []
      kanas.each do |letter|
        banks << get_banks_by_letter(letter)
      end
      banks
    end

    def get_all_kanas
      ("ｱ".."ﾝ").to_a.map{ |chr| NKF.nkf("-h1w", NKF.nkf("-Xw", chr)) }
    end

    def get_banks_by_letter(letter_first)
      # ホームページのリンクにアクセス
      page = agent.get('http://zengin.ajtw.net/')
      # letter_firstをクリック
      page = click_link(letter_first)
      # bankを取得してbanksに代入
      banks = scrape_bank_list
    end

    def scrape_bank_list
      banks = []
      tablerows = agent.page.search('table.tbl1 tr')
      # 最初の行はshift
      tablerows.shift
      tablerows.each do |tr|
        name = tr.css('td.g1:first-child').inner_text
        code = tr.css('td.g2').inner_text
        bank = Bank.new(code, name)
        banks << bank
      end
      banks
    end

    def test_process(letter_first, letter_second)
      # ホームページのリンクにアクセス
      page = agent.get('http://zengin.ajtw.net/')
      # きをクリック
      page = click_link(letter_first)
      # 一番上の支店をクリック
      page = click_siten_link
      # 支店検索ページのきをクリック
      page = click_siten_kana_link(letter_second)
      # 一覧ページをスクレイピング
      branches = scrape_branch_list
    end

    private
    # 指定したpageのurlとvalueからボタンをクリックする
    def click_link(target_value)
      form = agent.page.forms[0]
      button = form.button_with(:value => target_value)
      page = agent.submit(form, button)
    end

    def click_siten_link
      form = agent.page.forms[3]
      button = form.button_with(:value => "支店検索")
      page = agent.submit(form, button)
    end

    def click_siten_kana_link(target_value)
      form = agent.page.forms[1]
      button = form.button_with(:value => target_value)
      page = agent.submit(form, button)
    end

    def scrape_branch_list
      branches = []
      tablerows = agent.page.search('table.tbl1 tr')
      # 最初の行はshift
      tablerows.shift
      tablerows.each do |tr|
        name = tr.css('td.g1:first-child').inner_text
        code = tr.css('td.g2').inner_text
        bank = Bank.new(code, name)
        branches << bank
      end
      branches
    end
end
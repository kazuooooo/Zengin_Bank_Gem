require 'rubygems'
require 'nokogiri'
require 'mechanize'
require 'pry'
require_relative 'bank'

class Scraper
    attr_accessor :agent, :page, :home_page
    def initialize
      @agent = Mechanize.new
      @page = ''
      @home_page = agent.get('http://zengin.ajtw.net/')
    end
    
    # 全ての銀行一覧を取得
    def get_all_banks
      kanas = get_all_kanas
      banks = []
      kanas.each do |letter|
        banks << get_banks_by_letter(letter)
      end
      banks
    end

    # 指定したかなの銀行一覧を取得
    def get_banks_by_letter(letter)
      # letter_firstをクリック
      page = click_link(letter)
      # bankを取得してbanksに代入
      banks = scrape_bank_list
    end

    # ページから銀行一覧をスクレイピング
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

    # 支店一覧ページから全ての支店を取得
    def get_all_branches
      # ホームページのリンクにアクセス
      page = agent.get('http://zengin.ajtw.net/')
      # きをクリック
      page = click_link("き")
      kanas = get_all_kanas
      branches = []
      kanas.each do |letter|
        branches << get_branches_by_letter(letter)
      end
      pp branches
      branches
    end

    def get_branches_by_letter(letter)
      cached_page = click_siten_kana_link(letter)
      branches = scrape_branch_list
    end

    def scrape_branch_list(page)
      branches = []
      tablerows = page.search('table.tbl1 tr')
      # 最初の行はshift
      tablerows.shift
      tablerows.each do |tr|
        name = tr.css('td.g1:first-child').inner_text
        code = tr.css('td.g2').inner_text
        branch = Bank.new(code, name)
        branches << branch
      end
      p branches
      branches
    end

    def test_process(letter_first)
      # ホームページのリンクにアクセス
      page = agent.get('http://zengin.ajtw.net/')
      # きをクリック
      page = click_link(letter_first)
      # 一番上の支店をクリック
      page = click_siten_link
      # 全ての支店を取得
      branches = get_all_branches
    end

    private
    # 指定したpageのurlとvalueからボタンをクリックする
    def click_link(target_value)
      form = home_page.forms[0]
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

    # あ〜んまでのかなを取得
    def get_all_kanas
      ("ｱ".."ﾝ").to_a.map{ |chr| NKF.nkf("-h1w", NKF.nkf("-Xw", chr)) }
    end

end
require 'rubygems'
require 'nokogiri'
require 'mechanize'
require 'pry'
require_relative 'bank'

class Scraper
    attr_accessor :agent, :page, :home_page, :kanas
    def initialize
      @agent = Mechanize.new
      @page = ''
      @kanas = get_all_kanas
      @home_page = agent.get('http://zengin.ajtw.net/')
    end

      # 1.ホームページにアクセス(cache)
      # 2.金融機関の最初の文字をクリック(あーん)(cache)
      #   a. 支店検索をクリック（その仮名の銀行列分)
      #     い. 銀行名と金融機関コードを代入 
      #     ろ. 支店名の最初の文字をクリック(あーん)
      #       # get_branch_list_pages
      #       1. リストの列分の支店名、支店コードを代入
                # get_branches_from_list
      #       2. いに戻る
      #     は. bに戻る
      #   b. 2.に戻る
    def process
      # ホームページのリンクにアクセス
      page = agent.get('http://zengin.ajtw.net/')
      # きをクリック
      page = click_link("き")
      # 一番上の支店をクリック
      page = click_siten_link
      # 支店検索ページのきをクリック
      bank_home_page = page
      siten_list_pages= []
      
      #display_page_info(click_siten_kana_link(bank_home_page, "く"))

      # なぜか途中からおかしくなる。
      # pageはややこしいから使わなくする
      # 実行順を要確認
      kanas.each do |kana|
        siten_list_page = click_siten_kana_link(bank_home_page,kana)
        display_page_info(siten_list_page)
        siten_list_pages << siten_list_page
      end
      #page = click_siten_kana_link("き")
      # 一覧ページをスクレイピング
      # branches = []
      # siten_list_pages.each do |list_page|
      #   kana_branches = get_branches_from_list(list_page)
      #   branches << kana_branches
      # end
    end

    def display_page_info(list_page)
      info = list_page.search('span.f76')
      p info.inner_text
    end

    def click_siten_link
      form = agent.page.forms[3]
      button = form.button_with(:value => "支店検索")
      page = agent.submit(form, button)
    end

    # 全ての銀行一覧を取得
    def get_all_banks
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
    end

    def get_branches_from_list(branch_list_page)
      branches = []
      tablerows = branch_list_page.search('table.tbl1 tr')
      # 最初の行はshift
      tablerows.shift
      tablerows.each do |tr|
        name = tr.css('td.g1:first-child').inner_text
        code = tr.css('td.g2').inner_text
        branch = Branch.new(code, name)
        puts branch.code
        puts branch.name
        branches << branch
      end
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


    # 指定したpageのurlとvalueからボタンをクリックする
    def click_link(target_value)
      form = home_page.forms[0]
      button = form.button_with(:value => target_value)
      page = agent.submit(form, button)
    end

    def click_siten_kana_link(bank_home_page, kana)
      form = bank_home_page.forms[1]
      p "click" << kana
      button = form.button_with(:value => kana)
      p button
      list_page = agent.submit(form, button)
    end

    def click_bank_kana_link(kana)
      form = home_page.forms[1]
      button = form.button_with(:value => kana)
      page = agent.submit(form, button)
    end

    # あ〜んまでのかなを取得
    def get_all_kanas
      kanas = ("ｱ".."ﾜ").to_a.map{ |chr| NKF.nkf("-h1w", NKF.nkf("-Xw", chr)) }
      kanas << "A-Z"
      kanas.each do |kana|
        p kana
      end
      p kanas.length
      kanas
    end

end
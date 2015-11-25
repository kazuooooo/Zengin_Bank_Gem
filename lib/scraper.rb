require 'rubygems'
require 'nokogiri'
require 'mechanize'
require 'pry'
require_relative 'bank'

class Scraper
  attr_accessor :agent, :home_page, :kanas
  def initialize
    @agent = Mechanize.new
    @page = ''
    @kanas = get_all_kanas
    @home_page = agent.get('http://zengin.ajtw.net/')
  end
### Bank関連
  # 全ての銀行一覧を取得
  def get_all_banks
    banks = []
    kanas.each do |kana|
      banks << get_banks_by_letter(kana)
    end
    banks.flatten
  end

  # 指定したかなの銀行一覧を取得
  def get_banks_by_letter(kana)
    # letter_firstをクリック
    page = click_link(kana)
    # bankを取得してbanksに代入
    banks = scrape_bank_list
  end

  # 指定したpageのurlとvalueからボタンをクリックする
  def click_link(target_value)
    form = home_page.forms[0]
    button = form.button_with(:value => target_value)
    page = agent.submit(form, button)
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
##

### Branch関連
  def get_all_branches(bank_code)
    search_bank(bank_code)
    # 支店ホームページのあ〜A-Zをクリックした一覧ページを全て取得
    siten_list_pages = get_branch_list_pages
    # #各支店一覧ページから支店を取得
    branches = get_all_branches_from_list_pages(siten_list_pages)
    branches.flatten.each do |branch|
      puts branch.name
      puts branch.code
    end
    branches.flatten
  end

  def search_bank(bank_code)
    # コードから検索にアクセス
    agent.page.link_with( :text => "コードから検索<入力形式>" ).click
    # 金融機関コードにbank_codeを代入して検索
    form = agent.page.forms[0]
    form.inbc = bank_code
    agent.submit(form)
    # 支店検索をクリック
    form = agent.page.forms[1]
    agent.submit(form)
  end

  def get_branch_list_pages
    siten_list_pages = []
    kanas.each do |kana|
      siten_list_page = click_siten_kana_link(kana)
      display_page_info(siten_list_page)
      siten_list_pages << siten_list_page
    end
    siten_list_pages
  end

  def get_all_branches_from_list_pages(siten_list_pages)
    branches = []
    siten_list_pages.each do |list_page|
      kana_branches = get_branches_from_list(list_page)
      branches << kana_branches
    end
    # 空配列削除
    branches.delete([])
    branches
  end

  def get_branches_from_list(branch_list_page)
    branches = []
    tablerows = branch_list_page.search('table.tbl1 tr')
    # 最初の行はshift
    tablerows.shift
    tablerows.each do |tr|
      name = tr.css('td.g1:first-child').inner_text
      #データがない場合はスキップ
      if name == "該当するデータはありません"
        next
      end
      code = tr.css('td.g2').inner_text
      branch = Branch.new(code, name)
      branches << branch
    end
    branches
  end

  def click_siten_kana_link(kana)
    kana_form = agent.page.forms[1]
    button = kana_form.button_with(:value => kana)
    list_page = agent.submit(kana_form, button)
    #ページを取得したら前ページに戻る
    back_form = agent.page.forms[0]
    back_button = back_form.button_with(:value => "前ページに戻る")
    agent.submit(back_form, back_button)

    list_page
  end
##

### その他
  def go_back_page
    back_form = agent.page.forms[0]
    back_button = back_form.button_with(:value => "前ページに戻る")
    agent.submit(back_form, back_button)
  end

  def display_page_info(list_page)
    info = list_page.search('span.f76')
  end
      # あ〜んまでのかなを取得
  def get_all_kanas
    kanas = ("ｱ".."ﾜ").to_a.map{ |chr| NKF.nkf("-h1w", NKF.nkf("-Xw", chr)) }
    kanas << "A-Z"
  end
##
end
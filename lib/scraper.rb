require 'rubygems'
require 'nokogiri'
require 'mechanize'
require 'pry'
# スクレイプの基底クラス
# [SHOULD] メソッドの本体コードにコメントを書かなければ理解できないようなコードを書いてはならない。
# メソッド本体内にコメントを書くよりも、別のメソッドに分けて適切な名前を付ける方が可読性が向上する。
# ただし、数式に対する補足や出展などはコード本体中にコメントとして書いても良い
class Scraper
  attr_accessor :agent, :kanas

  def initialize
    @agent = Mechanize.new
    agent.get('http://zengin.ajtw.net/')
    @kanas = get_all_kanas
    agent.keep_alive = false
  end
  
  # 前ページに戻るを押下
  # @param [nil]
  # @return [Mechanize:Page] 遷移後のページを返す
  def go_back_page
    back_form = agent.page.forms[0]
    back_button = back_form.button_with(:value => "前ページに戻る")
    agent.submit(back_form, back_button)
  end

  # [tmp]デバッグ用
  def display_page_info(list_page)
    info = list_page.search('span.f76')
  end

  # サイトのボタンにあるあ〜A-Zまでのかなを取得
  # @param [nil]
  # @return [String[]] "あ"〜"A-Z"を返す
  def get_all_kanas
    kanas = [*"ｱ".."ﾜ"].map{ |chr| NKF.nkf("-h1w", NKF.nkf("-Xw", chr)) }
    kanas << "A-Z"
  end

  # 指定したpageのurlとvalueからボタンをクリックする
  # @param kana [String] "あ"〜"A-Z"までのかな
  # @param num [Int] 銀行かな => 0 支店かな => 1 
  # @return [Mecanize:Page] クリック後のページを返す
  def click_kana_link(kana, num)
    form = agent.page.forms[num]
    button = form.button_with(:value => kana)
    page = agent.submit(form, button)
  end
end
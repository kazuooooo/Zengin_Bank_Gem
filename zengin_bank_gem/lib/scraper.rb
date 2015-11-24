require 'rubygems'
require 'nokogiri'
require 'mechanize'
require 'pry'

class Scraper
    attr_accessor :agent, :page
    def initialize
      @agent = Mechanize.new
      @page = ''
      result = click_link('http://zengin.ajtw.net/', 'あ')
      pp result
    end

    private
    def click_link(page_url, target_value)
      page = agent.get(page_url)
      form = agent.page.form
      button = form.button_with(:value => target_value)
      result = agent.submit(form, button)
    end
    # def click_news
    #   agent = Mechanize.new
    #   page = agent.get('http://google.com/')
    #   # page内のリンクから特定のリンクをクリック
    #   # page = agent.page.links.find { |l| l.text == 'ニュース' }.click
    #     # ↑ の省略形で書けるメソッド
    #     page = agent.page.link_with(:text => 'ニュース').click
    #     # ニュースの２番目のリンクをクリック
    #     # agent.page.links_with(:text => 'News')[1].click
    #     # hrefなどの複数条件をつけることも可能
    #     # page.link_with(:text => 'News', :href => '/something')
    #   pp page
    # end

    # def input_text_to_form
    #   agent = Mechanize.new
    #   page = agent.get('http://google.com/')

    #   # formを取得
    #   google_form = page.form('f')
    #   google_form.q = 'ruby mechanize'
    #   page = agent.submit(google_form, google_form.buttons.first)
    #   pp page
    # end

end
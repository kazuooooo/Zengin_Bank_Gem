require 'singleton'
module Zengin
  class Scraper
    include Singleton
    # @!attribute agent
    #   @return [Mechanize] Mechanizeクライアント
    # @!attribute bank_kana_page
    #   @return [Mechanize::Page] 銀行のかな一覧ページ
    # @!attribute banks_list_pages
    #   @return [Mechanize::Page] 各かなの銀行一覧ページ
    # @!attribute bank_form
    #   @return [Mechanize::Form] 各かなボタンが含まれたフォーム
    attr_accessor :agent, :bank_kana_page, :banks_list_pages, :bank_form
    def initialize
      @agent = Mechanize.new
      @bank_kana_page = agent.get('http://zengin.ajtw.net/')
      @banks_list_pages = []
      @bank_form = bank_kana_page.form_with(action: /ginkou.php/)
      agent.log = Logger.new $stderr
      agent.keep_alive = false
    end

  ### Bank
    # 各かなの金融機関一覧ページを取得
    # @return [Mechanize::Page[]] 各かなの金融機関一覧ページ
    def get_banks_list_pages
      bank_form.buttons.map do |initial_kana_button|
        name, value = [initial_kana_button.name, initial_kana_button.value]
        bank_form.delete_field!(name)
        bank_form.add_field!(name, value)
        begin
          bank_form.submit
        rescue Exception => e
          p "retrying...bank_form.submit"
          retry
        end
      end
    end

  ### Branch
    # 引数で与えられた銀行のページから各かなの支店一覧ページを取得
    # @return [Mechanize::Page[]] 各かなの支店一覧ページ
    def get_branch_list_pages(branch_kana_page)
      raise 'ARGMENT MUST BE Mechanize::Page!!' unless branch_kana_page.is_a?(Mechanize::Page)
      branch_form = branch_kana_page.form_with(action: /shitenmeisai.php/)
      branch_form.buttons.map do |initial_kana_button|
        name, value = [initial_kana_button.name, initial_kana_button.value]
        branch_form.delete_field!(name)
        branch_form.add_field!(name, value)
        begin
          branch_form.submit
        rescue
          p "retrying...branch_form.submit"
          retry
        end
      end
    end
  end
end
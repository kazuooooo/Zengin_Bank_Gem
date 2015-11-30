require_relative 'scraper'
require_relative 'zengin_bank_gem'

class BankScraper < Scraper
  
  # 全ての銀行のページオブジェクトを取得
  # @param [nil]
  # @return [Mechanize::Page[]] 全ての銀行をBankオブジェクトの配列で返す
  def get_banks_list_pages
    bank_list_pages = []
    kanas.each do |kana|
      bank_list_pages << get_bank_list_page(kana)
    end
    bank_list_pages
  end

  # 指定したかなの銀行一覧を取得
  # @param [String] "あ"〜"A-Z"までのかな
  # @return [Bank[]] kanaで指定された頭文字のBankオブジェクトを配列で返す
  def get_bank_list_page(kana)
    page = click_kana_link(kana, 0)
    go_back_page
    page
  end

  # 銀行一覧のページから銀行をスクレイピングしてBankオブジェクト配列を作成
  # @param [nil]
  # @return [Bank[]] スクレイプした銀行一覧を返す
  # def scrape_bank_list(bank_list_page)
  #   banks = []
  #   tablerows = bank_list_page.search('table.tbl1 tr')
  #   tablerows.shift
  #   tablerows.each do |tr|
  #     name = tr.css('td.g1:first-child').inner_text
  #     if name == "該当するデータはありません"
  #       next
  #     end
  #     code = tr.css('td.g2').inner_text
  #     bank = Bank.new(code, name)
  #     banks << bank
  #   end
  #   banks
  # end

end
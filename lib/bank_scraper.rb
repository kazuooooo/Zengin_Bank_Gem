require_relative 'scraper'

class BankScraper < Scraper
  
  # 全ての銀行一覧を取得
  # @param [nil]
  # @return [Bankd[]] 全ての銀行をBankオブジェクトの配列で返す
  def get_all_banks
    banks = []
    kanas.each do |kana|
      banks << get_banks_by_letter(kana)
    end
    banks.flatten
  end

  # 指定したかなの銀行一覧を取得
  # @param [String] "あ"〜"A-Z"までのかな
  # @return [Bank[]] kanaで指定された頭文字のBankオブジェクトを配列で返す
  def get_banks_by_letter(kana)
    click_kana_link(kana)
    banks = scrape_bank_list
    go_back_page
    banks
  end

  # 銀行かな検索から指定したかなのリンクをクリック
  # @param [String] "あ"〜"A-Z"までのかな
  # @return [Mechanize:Page] 遷移後のページ
  def click_kana_link(kana)
    form = agent.page.forms[0]
    button = form.button_with(:value => kana)
    page = agent.submit(form, button)
  end

  # 銀行一覧ページからスクレイピングしてBankオブジェクトの配列を作成
  # @param [nil]
  # @return [Mechanize:Page] 遷移後のページ
  def scrape_bank_list
    banks = []
    tablerows = agent.page.search('table.tbl1 tr')
    tablerows.shift
    tablerows.each do |tr|
      name = tr.css('td.g1:first-child').inner_text
      if name == "該当するデータはありません"
        next
      end
      code = tr.css('td.g2').inner_text
      bank = Bank.new(code, name)
      banks << bank
    end
    banks
  end

end
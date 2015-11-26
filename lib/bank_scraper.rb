require_relative 'scraper'

class BankScraper < Scraper
  
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
    click_link(kana)
    banks = scrape_bank_list
    go_back_page
    banks
  end

  # 指定したpageのurlとvalueからボタンをクリックする
  def click_link(kana)
    form = agent.page.forms[0]
    button = form.button_with(:value => kana)
    page = agent.submit(form, button)
  end

  # ページから銀行一覧をスクレイピング
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
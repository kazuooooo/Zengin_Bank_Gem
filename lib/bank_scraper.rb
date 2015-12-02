require_relative 'scraper'
require_relative 'zengin_bank_gem'

class BankScraper < Scraper
  
  def get_banks_list_pages
    bank_list_pages = []
    kanas.each do |kana|
      bank_list_pages << get_bank_list_page(kana)
    end
    bank_list_pages
  end

  def get_bank_list_page(kana)
    page = click_kana_link(kana, 0)
    go_back_page
    page
  end

end
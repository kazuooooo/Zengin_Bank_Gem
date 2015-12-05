require 'pry'
class BankScraper < Scraper

  # def get_banks_list_pages
  #   bank_forms = bank_kana_page.form_with(action: /ginkou.php/)
  #   binding.pry
  # end
  # def get_banks_list_pages
  #   bank_list_pages = []
  #   bank_form = bank_page.form_wit(action: /ginkou.php/)
  #   kanas.each do |kana|
  #     bank_list_pages << get_bank_list_page(kana)
  #   end
  #   bank_list_pages
  # end

  # def get_bank_list_page(kana)
  #   page = click_kana_link(kana, 0)
  #   go_back_page
  #   page
  # end

end
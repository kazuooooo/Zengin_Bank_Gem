require_relative "./zengin_bank_gem/version"
require_relative "bank_scraper.rb"

module Zengin

  class BankCollection
    include Enumerable

    def each
      return self unless block_given?
      bank_scraper = BankScraper.new
      bank_scraper.get_banks_list_pages.each do |page|
        tablerows = page.search('table.tbl1 tr')
        tablerows.shift
        tablerows.each do |tr|
          name = tr.css('td.g1:first-child').inner_text
          if name == "該当するデータはありません"
            next
          end
          yomi = tr.css('td.g1:nth-child(2)').inner_text
          bank_code = tr.css('td.g2').inner_text
          bank = Bank.new(bank_code, name, yomi)
          yield bank
        end
      end
    end
  end

  def banks
    BankCollection.new
  end
end
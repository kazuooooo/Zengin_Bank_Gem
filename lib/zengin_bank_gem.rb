require 'rubygems'
require 'nokogiri'
require 'mechanize'
require 'scraper'
require 'zengin_bank_gem/version.rb'
require 'bank_scraper'
require 'bank'
require 'branch_scraper.rb'

module Zengin

  class BankCollection
    include Enumerable

    def each
      return self unless block_given?
      bank_scraper = BankScraper.new
      bank_scraper.get_banks_list_pages.each do |page|
        next if no_bank?(page)
        tablerows = page.search('table.tbl1 tr')
        tablerows.shift
        tablerows.each do |tr|
          name = tr.css('td.g1:first-child').inner_text
          yomi = tr.css('td.g1:nth-child(2)').inner_text
          bank_code = tr.css('td.g2').inner_text
          bank = Bank.new(bank_code, name, yomi)
          yield bank
        end
      end
    end

    def no_bank?(page)
      text = page.search('table.tbl1 tr td.g1:first-child').inner_text
      text == '該当するデータはありません'
    end

  end

  def banks
    BankCollection.new
  end

  module_function :banks

end
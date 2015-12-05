require 'rubygems'
require 'nokogiri'
require 'mechanize'
require 'pry'
require 'scraper'
require 'bank_scraper'
require 'bank'
require 'branch_scraper.rb'
require 'csv'

module Zengin

  class BankCollection
    include Enumerable

    attr_accessor :bank_scraper
    def initialize
      @bank_scraper = Scraper.instance
    end

    def each
      return self unless block_given?
      bank_scraper.get_banks_list_pages.each do |page|
        name, yomi, code = '', '', ''
        page_html = Nokogiri::HTML(page.body)
        page_html.css('table.tbl1 tr:not(:first-child)').each_with_index do |tr, index|
          name, yomi, code = tr.css('td.g1, td.g2').map{ |td| td.text }
          next unless name && yomi && code
          # 支店の一覧ページを保存しておく
          branch_form = page.forms_with(action: /shiten.php/)
          branch_kana_page = branch_form[index].submit
          bank = Bank.new(code, name, yomi, branch_kana_page)
          yield bank
        end
      end
    end

  end

  def banks
    BankCollection.new
  end

  module_function :banks

  def mk_csv_file
    banks.each do |bank|
      bank.branches.each do |branch|
        CSV.open("zengin_test.csv", "w") do |csv|
          csv << CSV.generate_line([
                                  branch.bank_name,
                                  bank.yomi,
                                  branch.bank_code,
                                  branch.branch_name,
                                  branch.yomi,
                                  branch.branch_code,
                                  ])
        end
      end
    end
  end

end
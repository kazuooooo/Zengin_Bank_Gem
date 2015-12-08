require 'rubygems'
require 'nokogiri'
require 'mechanize'
require 'pry'
require 'scraper'
require 'bank'
require 'csv'
require 'vcr'

module Zengin

  class BankCollection
    include Enumerable

    attr_accessor :scraper
    def initialize
      @scraper = Scraper.instance
    end

    def each
      return self unless block_given?
      scraper.get_banks_list_pages.each do |page|
        # name, yomi, code = '', '', ''
        page_html = Nokogiri::HTML(page.body)
        page_html.css('table.tbl1 tr:not(:first-child)').each_with_index do |tr, index|
          bank_name, bank_yomi, bank_code = tr.css('td.g1, td.g2').map{ |td| td.text }
          next unless bank_name && bank_yomi && bank_code
          # 支店の一覧ページを保存しておく
          branch_form = page.forms_with(action: /shiten.php/)
          branch_kana_page = branch_form[index].submit
          bank = Bank.new(bank_code, bank_name, bank_yomi, branch_kana_page)
          yield bank
        end
      end
    end
  end

  def banks
    BankCollection.new
  end

  module_function :banks

  def mk_csv_file(file_name)
    # ヘッダー追加
    CSV.open("#{file_name}.csv", "w") do |csv|
            csv << [
                    '金融機関名',
                    'フリガナ',
                    '金融機関コード',
                    '支店名',
                    'フリガナ',
                    '支店コード',
                    ]
    end

    banks.each do |bank|
      CSV.open("#{file_name}.csv", "a") do |csv|
        bank.branches.each do |branch|
          csv << [
                  branch.bank_name,
                  bank.bank_yomi,
                  branch.bank_code,
                  branch.branch_name,
                  branch.branch_yomi,
                  branch.branch_code,
                  ]
        end
        p "finish #{bank.bank_name}"
      end
    end
  end

  module_function :mk_csv_file

end
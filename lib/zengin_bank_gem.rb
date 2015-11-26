require_relative "./zengin_bank_gem/version"
require_relative "bank_scraper.rb"

module Zengin
  include Enumerable

  def each
    Zengin.banks.each do |bank|
      yield bank
    end
  end

  # @return [Enumerator] 銀行
  def banks
    bank_scraper = BankScraper.new
    banks = bank_scraper.get_all_banks.to_enum
  end

end
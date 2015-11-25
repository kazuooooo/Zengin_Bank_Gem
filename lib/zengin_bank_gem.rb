require_relative "./zengin_bank_gem/version"
require_relative "scraper.rb"

module Zengin
  include Enumerable

  def each
    Zengin.banks.each do |bank|
      yield bank
    end
  end

  # @return [Enumerator] 銀行
  def banks
    scraper = Scraper.new
    banks = scraper.get_all_banks.to_enum
  end

end
require_relative "./zengin_bank_gem/version"

module Zengin
  include Enumerable

  def each
    Zengin.banks.each do |bank|
      yield bank
    end
  end

  # @return [Enumerator] 銀行
  def banks
    # success
    # @banks = [
    #   Branch.new( 1,"b1" ),
    #   Branch.new( 2,"b2" ),
    #   Branch.new( 3,"b1" )
    # ].to_enum

    # fail
    # 10
    scraper = Scraper.new
    banks = scraper.get_all_banks.to_enum
  end
end

# Zengin.banks.each do |bank|
#   bank.branches.each do |branch|
#   end
# end

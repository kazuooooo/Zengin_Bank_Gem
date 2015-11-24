require "zengin_bank_gem/version"

module Zengin
  include Enumerable

  def each
    @zengin.each do |bank|
      yield bank
    end
  end

  # @return [Enumerator] 銀行
  def banks
  end
end


Zengin.banks.each do |bank|
  bank.branches.each do |branch|
  end
end

require "zengin_bank_gem/version"

module Zengin
  include Enumerable
  # 銀行
  class Bank
    include Enumerable
    attr_accessor :code, :name
    
    def initialize(code, name)
      @code = code
      @name = name
    end

    def each

    end
    # @return[Enumerator] 支店
    def branches
    end

  end

  # 支店
  class Branch
    attr_accessor :code, :name
    
    def initialize(code, name)
      @code = code
      @name = name
    end
  end

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

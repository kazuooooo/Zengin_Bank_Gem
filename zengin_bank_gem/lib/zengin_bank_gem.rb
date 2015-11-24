require "zengin_bank_gem/version"

module ZenginBankGem
  # 銀行
  class Bank
    attr_accessor :code, :name
    def initialize(code, name)
      @code = code
      @name = name
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

  # @return [Enumerator] 銀行
  def banks

  end
end

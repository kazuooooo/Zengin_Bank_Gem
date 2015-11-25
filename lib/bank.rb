require_relative 'branch'
require_relative 'scraper'
# 銀行クラス
class Bank

  include Enumerable
  attr_accessor :code, :name
  
  def initialize(code, name)
    @code = code
    @name = name
  end

  def each
    branches.each do |branch|
      yield branch
    end
  end

  # @return[Enumerator] 支店
  def branches
    scraper = Scraper.new
    branches = scraper.get_all_branches(code)
    branches.to_enum
  end

end
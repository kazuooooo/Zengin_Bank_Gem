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
    # success
    # @bank = [
    #   Branch.new( 1,"b1" ),
    #   Branch.new( 2,"b2" ),
    #   Branch.new( 3,"b1" )
    # ].to_enum

    # fail
    # 10
    # scraper = Scraper.new
    # branches = scraper.test_process('ま', 'と')
    # branches.to_enum
  end

end
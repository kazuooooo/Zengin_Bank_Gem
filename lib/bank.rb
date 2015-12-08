class Bank
  # @!attribute bank_code
  #   @return [Int] 金融機関コード
  # @!attribute bank_name
  #   @return [String] 金融機関名
  # @!attribute bank_yomi
  #   @return [String] 金融機関のフリガナ
  # @!attribute branch_kana_page
  #   @return [Mechanize::Page] 支店のかな一覧ページ
  attr_accessor :bank_code, :bank_name, :bank_yomi, :branch_kana_page
  def initialize(bank_code, bank_name, bank_yomi, branch_kana_page)
    @bank_code = bank_code
    @bank_name = bank_name
    @bank_yomi = bank_yomi
    @branch_kana_page = branch_kana_page
  end

  # EnumerableなBranchCollectionを返す
  # @return [BankCollection] BankCollection
  # @example
  #   Zengin.banks => [BankCollection] 
  def branches
    BranchCollection.new(bank_code, bank_name, branch_kana_page)
  end

  class Branch
    # @!attribute bank_code
    #   @return [Int] 金融機関コード
    # @!attribute bank_name
    #   @return [String] 金融機関名
    # @!attribute branch_code
    #   @return [Int] 支店コード
    # @!attribute branch_name
    #   @return [String] 支店名
    # @!attribute branch_yomi
    #   @return [String] 支店のフリガナ
    attr_accessor :bank_name, :bank_code, :branch_code, :branch_name, :branch_yomi
    def initialize(bank_name, bank_code, branch_code, branch_name, branch_yomi)
      @bank_name = bank_name
      @bank_code = bank_code
      @branch_code = branch_code
      @branch_name = branch_name
      @branch_yomi = branch_yomi
    end

  end

  class BranchCollection
    include Enumerable
    # @!attribute bank_code
    #   @return [Int] 金融機関コード
    # @!attribute bank_name
    #   @return [String] 金融機関名
    # @!attribute branch_kana_page
    #   @return [Mechanize::Page] 支店のかな一覧ページ
    # @!attribute scraper
    #   @return [Scraper] Scraperインスタンス
    attr_accessor :bank_code, :bank_name, :branch_kana_page, :scraper
    def initialize(bank_code, bank_name, branch_kana_page)
      @bank_code = bank_code
      @bank_name = bank_name
      @branch_kana_page = branch_kana_page
      @scraper = Scraper.instance
    end

    def each
      return self unless block_given?
      scraper.get_branch_list_pages(branch_kana_page).each do |page|
        branches_page_html = Nokogiri::HTML(page.body)
        branches_page_html.css('table.tbl1 tr:not(:first-child)').each_with_index do |tr, index|
          branch_name, branch_yomi, branch_code = tr.css('td.g1, td.g2').map{ |td| td.text }
          next unless branch_name && branch_yomi && branch_code
          branch = Branch.new(bank_name, bank_code, branch_code, branch_name, branch_yomi)
          yield branch
        end
      end
    end
  end

end
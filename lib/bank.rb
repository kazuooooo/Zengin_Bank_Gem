class Bank
  
  attr_accessor :bank_code, :bank_name, :bank_yomi, :branch_kana_page
  def initialize(bank_code, bank_name, bank_yomi, branch_kana_page)
    @bank_code = bank_code
    @bank_name = bank_name
    @bank_yomi = bank_yomi
    @branch_kana_page = branch_kana_page
  end

  class Branch
    
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

    attr_accessor :bank_code, :bank_name, :branch_kana_page, :scraper
    def initialize(bank_code, bank_name, branch_kana_page)
      @bank_code = bank_code
      @bank_name = bank_name
      @branch_kana_page = branch_kana_page
      @scraper = Scraper.instance
    end

    def each
      return self unless block_given?
      # 毎回newする必要ない
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
    
    def no_branch?(page)
      text = page.search('table.tbl1 tr td.g1:first-child').inner_text
      text == '該当するデータはありません'
    end
  end

  def branches
    BranchCollection.new(bank_code, bank_name, branch_kana_page)
  end

end
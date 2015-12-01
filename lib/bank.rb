require_relative '../lib/branch_scraper.rb'
class Bank

  attr_accessor :bank_code, :name

  def initialize(code, name)
    @bank_code = code
    @name = name
  end

  class Branch
    attr_accessor :branch_code, :name
    def initialize(code, name)
      @branch_code = code
      @name = name
    end
  end

  class BranchCollection
    include Enumerable

    attr_accessor :bank_code

    def initialize(code)
      @bank_code = code
    end

    def each
      return self unless block_given?
      branch_scraper = BranchScraper.new
      branch_scraper.search_bank(bank_code)
      branch_scraper.get_branch_list_pages.each do |page|
        tablerows = page.search('table.tbl1 tr')
        tablerows.shift
        tablerows.each do |tr|
          name = tr.css('td.g1:first-child').inner_text
          if name == "該当するデータはありません"
            next
          end
          branch_code = tr.css('td.g2').inner_text
          branch = Branch.new(branch_code, name)
          yield branch
        end
      end
    end
  end

  def branches
    BranchCollection.new(bank_code)
  end

end
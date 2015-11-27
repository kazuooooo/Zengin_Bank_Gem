require_relative 'scraper'
require 'pry'

class BranchScraper < Scraper

  # 指定した金融機関コードの銀行の全ての支店を取得
  # @param [String] 金融機関コード
  # @return [Branch[]] bank_codeで指定された銀行の支店をBranchオブジェクトの配列で返す
  def get_all_branches(bank_code)
    branches = []
    search_bank(bank_code)
    kanas.each do |kana|
      branches << get_branches_by_kana(kana)
    end
    branches.flatten
  end

  # 指定した金融機関コードで検索をかけてその銀行の支店かな検索ページを返す
  # @param [String] 金融機関コード
  # @return [Mechanize:Page] 遷移後のページを返す
  def search_bank(bank_code)
    agent.page.link_with( :text => "コードから検索<入力形式>" ).click
    form = agent.page.forms[0]
    form.inbc = bank_code
    agent.submit(form)
    form = agent.page.forms[1]
    agent.submit(form)
  end

  def get_branches_by_kana(kana)
    click_kana_link(kana, 1)
    branches = scrape_branch_list
    go_back_page
    branches
  end

  # 支店一覧ページ(個別かな)からの支店を取得
  # @param [Mechanize:Page] 支店一覧ページ
  # @return [Branch[]] Branchオブジェクトの配列
  def scrape_branch_list
    branches = []
    tablerows = agent.page.search('table.tbl1 tr')
    tablerows.shift
    tablerows.each do |tr|
      name = tr.css('td.g1:first-child').inner_text
      if name == "該当するデータはありません"
        next
      end
      code = tr.css('td.g2').inner_text
      branch = Branch.new(code, name)
      branches << branch
    end
    branches
  end

end
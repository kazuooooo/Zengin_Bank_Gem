require_relative 'scraper'

class BranchScraper < Scraper

  # 指定した金融機関コードの銀行の全ての支店を取得
  # @param [String] 金融機関コード
  # @return [Branch[]] bank_codeで指定された銀行の支店をBranchオブジェクトの配列で返す
  def get_all_branches(bank_code)
    search_bank(bank_code)
    branch_list_pages = get_branch_list_pages
    branches = get_all_branches_from_list_pages(branch_list_pages)
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

  # 銀行の支店かな検索ページの各かなをクリックして各かなの支店一覧ページ全て配列で取得
  # @param [nil]
  # @return [Mechanize:Page[]] "あ"〜"A-Z"までの各支店一覧ページを返す
  def get_branch_list_pages
    branch_list_pages = []
    kanas.each do |kana|
      siten_list_page = click_siten_kana_link(kana)
      display_page_info(siten_list_page)
      branch_list_pages << siten_list_page
    end
    branch_list_pages
  end

  # 各支店一覧ページから全ての支店を取得
  # @param [Mechanize:Page[]] "あ"〜"A-Z"までの各支店一覧ページ
  # @return [Branch[]] Branchオブジェクトの配列
  def get_all_branches_from_list_pages(branch_list_pages)
    branches = []
    branch_list_pages.each do |branch_list_page|
      kana_branches = get_branches_from_list_page(branch_list_page)
      branches << kana_branches
    end
    branches.delete([])
    branches
  end

  # 支店一覧ページ(個別かな)からの支店を取得
  # @param [Mechanize:Page] 支店一覧ページ
  # @return [Branch[]] Branchオブジェクトの配列
  def get_branches_from_list_page(branch_list_page)
    branches = []
    tablerows = branch_list_page.search('table.tbl1 tr')
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

  # 支店かな検索から指定したかなのリンクをクリック
  # @param [String] "あ"〜"A-Z"までのかな
  # @return [Mechanize:Page] 遷移後のページ
  def click_siten_kana_link(kana)
    kana_form = agent.page.forms[1]
    button = kana_form.button_with(:value => kana)
    list_page = agent.submit(kana_form, button)
    back_form = agent.page.forms[0]
    back_button = back_form.button_with(:value => "前ページに戻る")
    agent.submit(back_form, back_button)
    list_page
  end

end
require_relative 'scraper'

class BranchScraper < Scraper

  def search_bank(bank_code)
    agent.page.link_with( :text => "コードから検索<入力形式>" ).click
    form = agent.page.forms[0]
    form.inbc = bank_code
    agent.submit(form)
    form = agent.page.forms[1]
    agent.submit(form)
  end
  
  def get_branch_list_pages
    branch_list_pages = []
    kanas.each do |kana|
      page = click_kana_link(kana, 1)
      branch_list_pages << page
      go_back_page
    end
    branch_list_pages
  end

end
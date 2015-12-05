class Scraper
  
  attr_accessor :agent, :bank_kana_page, :banks_list_pages
  def initialize
    @agent = Mechanize.new
    @bank_kana_page = agent.get('http://zengin.ajtw.net/')
    @banks_list_pages = []
    @branch_kana_pages = []
    #agent.log = Logger.new $stderr
    agent.keep_alive = false
    agent.read_timeout = 180
  end

### Bank
  def get_banks_list_pages
    bank_form = bank_kana_page.form_with(action: /ginkou.php/)
    bank_form.buttons.each do |initial_kana_button|
      banks_list_pages << begin
                            bank_form.click_button(initial_kana_button)
                          rescue
                            retry
                          end
    end
    banks_list_pages
  end

### Branch
  # def search_bank(bank_code)
  #   agent.page.link_with( :text => 'コードから検索<入力形式>' ).click
  #   form = agent.page.forms[0]
  #   form.inbc = bank_code
  #   agent.submit(form)
  #   form = agent.page.forms[1]
  #   agent.submit(form)
  # end
  
  def get_branch_list_pages(branch_kana_page)
    branch_pages = []
    branch_form = branch_kana_page.form_with(action: /shitenmeisai.php/)
    branch_form.buttons.each do |initial_kana_button|
      branch_pages << branch_form.click_button(initial_kana_button)
      # begin
      #                 branch_form.click_button(initial_kana_button)
      #               rescue Exception => e
      #                 retry
      #               end
    end
    branch_pages
  end

# Zengin.banks.find do |bank|
# bank.name == "みなと銀行"
# end

  # 前ページに戻るを押下
  # @param [nil]
  # @return [Mechanize:Page] 遷移後のページを返す
  # def go_back_page
  #   back_form = agent.page.forms[0]
  #   back_button = back_form.button_with(:value => '前ページに戻る')
  #   p "go back page"
  #   agent.submit(back_form, back_button)
  # end

  # [tmp]デバッグ用
  # def display_page_info(list_page)
  #   info = list_page.search('span.f76')
  # end

  # サイトのボタンにあるあ〜A-Zまでのかなを取得
  # @param [nil]
  # @return [String[]] 'あ'〜'A-Z'を返す
  # def get_all_kanas
  #   kanas = [*'ｱ'..'ﾜ'].map{ |chr| NKF.nkf('-h1w', NKF.nkf('-Xw', chr)) }
  #   kanas << 'A-Z'
  # end

  # 指定したpageのurlとvalueからボタンをクリックする
  # @param kana [String] 'あ'〜'A-Z'までのかな
  # @param num [Int] 銀行かな => 0 支店かな => 1 
  # @return [Mecanize:Page] クリック後のページを返す
  # def click_kana_link(kana, num)
  #   form = agent.page.forms[num]
  #   button = form.button_with(:value => kana)
  #   p "click" << kana
  #   page = agent.submit(form, button)
  # end

end
require 'singleton'

class Scraper
  include Singleton

  attr_accessor :agent, :bank_kana_page, :banks_list_pages, :bank_form
  def initialize
    @agent = Mechanize.new
    @bank_kana_page = agent.get('http://zengin.ajtw.net/')
    @banks_list_pages = []
    @branch_kana_pages = []
    @bank_form = bank_kana_page.form_with(action: /ginkou.php/)
    agent.log = Logger.new $stderr
    agent.keep_alive = false
    # agent.read_timeout = 180
  end

### Bank
### Bank
  def get_banks_list_pages
    banks_list_pages = []
    bank_form.buttons.map do |initial_kana_button|
      name, value = [initial_kana_button.name, initial_kana_button.value]
      bank_form.add_field! name unless @bank_form.has_field?(name)
      bank_form.field_with(name: name).value = value
      banks_list_pages << begin
                            bank_form.submit
                          rescue Exception => e
                            p "retrying...bank_form.click_button(initial_kana_button)"
                            retry
                          end
    end
    banks_list_pages
  end

### Branch
  def get_branch_list_pages(branch_kana_page)
    bank_kana_page = agent.get('http://zengin.ajtw.net/')
    branch_list_pages = []
    branch_form = branch_kana_page.form_with(action: /shitenmeisai.php/)
    branch_form.buttons.each do |initial_kana_button|
      branch_list_pages << begin
                             branch_form.click_button(initial_kana_button)
                           rescue Exception => e
                             p "retrying...branch_form.click_button(initial_kana_button)"
                             retry
                           end
    end
    branch_list_pages
  end

end
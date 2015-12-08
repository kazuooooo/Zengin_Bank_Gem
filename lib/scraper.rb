require 'singleton'

class Scraper
  include Singleton

  attr_accessor :agent, :bank_kana_page, :banks_list_pages, :bank_form
  def initialize
    @agent = Mechanize.new
    @bank_kana_page = agent.get('http://zengin.ajtw.net/')
    @banks_list_pages = []
    @bank_form = bank_kana_page.form_with(action: /ginkou.php/)
    agent.log = Logger.new $stderr
    agent.keep_alive = false
    # agent.read_timeout = 180
  end

### Bank
  def get_banks_list_pages
    bank_form.buttons.map do |initial_kana_button|
      name, value = [initial_kana_button.name, initial_kana_button.value]
      bank_form.delete_field!(name)
      bank_form.add_field!(name, value)
      begin
        bank_form.submit
      rescue Exception => e
        p "retrying...bank_form.submit"
        retry
      end
    end
  end

### Branch
  def get_branch_list_pages(branch_kana_page)
    branch_form = branch_kana_page.form_with(action: /shitenmeisai.php/)
    branch_form.buttons.map do |initial_kana_button|
      name, value = [initial_kana_button.name, initial_kana_button.value]
      #かな
      branch_form.delete_field!(name)
      branch_form.add_field!(name, value)
      begin
        branch_form.submit
      rescue
        p "retrying...branch_form.submit"
        retry
      end
    end
  end
end
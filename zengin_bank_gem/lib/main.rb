require 'rubygems'
require 'mechanize'
require_relative './scraper'
require_relative './zengin_bank_gem'

# sc = Scraper.new
# Bank.new("10","test").branches

class Dummy
  include Zengin
end

Dummy.new.banks



require 'rubygems'
require 'mechanize'
require 'nkf'
require_relative './scraper'
require_relative './zengin_bank_gem'

class Dummy
  include Zengin
end

# Dummy.new.banks

require 'spec_helper'
require_relative '../lib/scraper.rb'

RSpec.describe Scraper do

  describe 'get_all_kanas' do 
    subject(:scraper){ Scraper.new }
    
    it 'return 45 letters' do
      expect(scraper.get_all_kanas.length).to eq(45)
    end

    it 'include "A-Z"' do
      expect(scraper.get_all_kanas).to include("A-Z")
    end

  end

end
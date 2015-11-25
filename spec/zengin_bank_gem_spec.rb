require_relative 'spec_helper'
require_relative '../lib/zengin_bank_gem.rb'
require_relative '../lib/testclass.rb'
require 'pry'

RSpec.describe Zengin do

  describe "#banks" do
    let(:test_class) { TestClass.new }
    it 'banks return Enumerator' do
      expect(test_class.banks).to be_kind_of(Enumerator)
    end

    context 'find by name "みずほ銀行"' do
      it 'return "0001"' do
        expect(test_class.banks.find{|bank|
          bank.name == "みずほ銀行"
          }.code).to eq("0001")
      end
    end

    context 'find by code "5234"' do
      it 'return "中巨摩東部農業協同組合"' do
        expect(test_class.banks.find{|bank|
          bank.code == "5234"
          }.name).to eq("中巨摩東部農業協同組合")
      end
    end

    it 'no overlaps' do
      expect(test_class.banks.to_a.uniq.length).to eq(test_class.banks.to_a.length)
    end
  end
  
  describe "#put all" do
    let(:test_class) { TestClass.new }
    it "test put" do
      banks = test_class.banks
      banks.each do |bank|
        puts "銀行名" << bank.name
        puts "金融機関コード" << bank.code
        branches = bank.branches
        # branches.each do |branch|
        #   puts branch.name
        #   puts branch.code
        # end
      end
      puts "FINISH ALL!!!"
    end
  end
end
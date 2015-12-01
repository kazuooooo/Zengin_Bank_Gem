require_relative 'zengin_bank_gem'
class Sample
  include Zengin # need to include Zengin Module
end

sample = Sample.new

# put all banks properties
sample.banks.each do |bank|
  puts bank.bank_code
  puts bank.name
  puts bank.yomi
end

# you can use Enumerable Methods (ex: find method)
somebank = sample.banks.each.find do |bank|
              bank.name == "みなと銀行"
           end

# puts somebank's all branches properties
somebank.branches.each do |branch|
  puts branch.branch_code
  puts branch.name
  puts branch.yomi
end

# Enumerable Methods can use on branches(ex: count)
p somebank.branches.each.count

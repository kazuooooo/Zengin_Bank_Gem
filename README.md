# zengin-ruby

### zengin-ruby
Welcome, this is zengin-ruby gem. By using this gem, you can use
Japanese banks information scraping from Zengin System (http://zengin.ajtw.net/)

### Installation

Add this line to your application's Gemfile:
```
gem 'zengin'
```

And then execute:
```
$ bundle
```

Or install it yourself as:
```
$ gem install zengin-ruby
```
### Usage

Include Zengin Module in Class.
```
class SomeClass
  include Zengin
end
```
 
Then you can use ClassName.banks method, it return Enumerable BankCollection object.
Bank object has bank_code, name and yomi properties.
```
someclass.banks 
# => Enumerable BankCollection
```
 
Moreover, Bank Object has branches method, it return Enumerable BranchCollection oject.
Branch object has branch_code, name and yomi properties.
```
somebank.branches
# => Enumerable BranchCollection
```

For more detail, please check sample below.

### Sample
```ruby
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

# you can use Enumerable Methods on banks(ex: find method)
somebank = sample.banks.each.find do |bank|
              bank.name == "○○銀行"
           end

# puts somebank's all branches properties
somebank.branches.each do |branch|
  puts branch.branch_code
  puts branch.name
  puts branch.yomi
end

# Enumerable Methods can use on branches(ex: count)
p somebank.branches.each.count
```
### Development

### Contributing

### Licence
The gem is available as open source under the terms of the MIT License.

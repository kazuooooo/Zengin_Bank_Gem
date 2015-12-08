### Zengin_Bank_Gem
Welcome, this is zengin-ruby gem. By using this gem, you can use
**Japanese banks** information scraping from Zengin System (http://zengin.ajtw.net/)

### Installation

Add this line to your application's Gemfile:
```
gem 'zengin_bank_gem'
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

require Zengin Module in Class.
```ruby
require 'zengin_bank_gem'
```
 
Then you can use Zengin.banks method, it return Enumerable BankCollection object.
Bank object has bank_code, name and yomi properties.
```
Zengin.banks 
# => Return Enumerable BankCollection
```
 
Moreover, Bank Object has branches method, it return Enumerable BranchCollection oject.
Branch object has branch_code, name and yomi properties.
```
Zengin.banks.each do |bank|
  bank.branches
  # => Enumerable BranchCollection
end
```

For more detail, please check sample below.

### Sample
```ruby
require 'zengin_bank_gem'

# put all banks properties
Zengin.banks.each do |bank|
  puts bank.bank_code
  puts bank.bank_name
  puts bank.bank_yomi
end

# you can use Enumerable Methods on banks(ex: find method)
somebank = Zengin.banks.each.find do |bank|
              bank.name == "○○銀行"
           end

# puts somebank's branches properties
somebank.branches.each do |branch|
  puts branch.branch_code
  puts branch.bramch_name
  puts branch.branch_yomi
end

# Enumerable Methods can use on branches(ex: count)
p somebank.branches.each.count
```
### Development
After checking out the repo, run bin/setup to install dependencies. Then, run rake spec to run the tests. You can also run bin/console for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run bundle exec rake install. To release a new version, update the version number in version.rb, and then run bundle exec rake release, which will create a git tag for the version, push git commits and tags, and push the .gem file to [rubygems.org](https://rubygems.org).

### Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/Zengin_Bank_Gem. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org/version/1/3/0/) code of conduct.

### Licence
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

require_relative 'spec_helper'
require_relative '../lib/zengin_bank_gem.rb'
require_relative '../lib/main.rb'


RSpec.describe Zengin do
  let(:dummy_class) { Dummy.new }
  it 'banks return Enumerator' do
    expect(dummy_class.banks).to be_kind_of(Enumerator)
  end
end
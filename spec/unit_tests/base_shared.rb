require 'spec_helper'

RSpec.shared_examples 'Wirecard::Base#defaults' do
  it { expect(subject[:customer_id]).to eq(config[:customer_id]) }
  it { expect(subject[:shop_id]).to eq(config[:shop_id]) }
end

RSpec.shared_examples 'Wirecard::Base' do
  
  let(:base) { Wirecard::Base.new }
  let(:customer_id) { 'customer1' }
  let(:shop_id) { 'shop1' }
  let(:url) { 'http://example.com' }
  
  before do
    allow_any_instance_of(Wirecard::Base).to receive(:url).and_return(url) # set dummy url
    Wirecard::Base.config = { customer_id: customer_id, shop_id: shop_id }
  end
  
  describe '#defaults' do
    subject { base.defaults }
    
    it { expect(subject[:customer_id]).to eq customer_id }
    it { expect(subject[:shop_id]).to eq shop_id }
  end
  
  describe '#uri' do
    subject { base.send(:uri) }
    
    it { is_expected.to be_a_kind_of(URI::HTTP) }
    it { expect(subject.to_s).to eq(url) }
  end
  
end
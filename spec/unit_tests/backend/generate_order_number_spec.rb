require 'spec_helper'

RSpec.describe Wirecard::Backend::GenerateOrderNumber do
  
  let(:generate_order_number) { Wirecard::Backend::GenerateOrderNumber.new(options) }
  let(:options) { Hash.new }
  
  include_context 'configuration'
  
  it { is_expected.to be_a_kind_of(Wirecard::Backend::GenerateOrderNumber) }
  
  describe '#implicit_fingerprint_order' do
    subject { generate_order_number.implicit_fingerprint_order }

    it { is_expected.to eq([:customer_id, :shop_id, :password, :secret, :language]) }
  end

  describe '#defaults' do
    subject { generate_order_number.defaults }

    include_examples 'Wirecard::Base#defaults'
    include_examples 'Wirecard::Backend::Base#defaults'
  end
  
  describe '#url' do
    subject { generate_order_number.url }
    
    it { is_expected.to eq('https://checkout.wirecard.com/seamless/backend/generateordernumber') }
  end
  
  describe '#post' do
    subject { generate_order_number.post.response }
    include_context 'stub requests'
    
    it { is_expected.to eq({ order_number: '1113051', status: '0' }) }
  end
end
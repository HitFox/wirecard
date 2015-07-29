require 'spec_helper'

RSpec.describe Wirecard::Backend::GetOrderDetails do
  
  let(:get_order_details) { Wirecard::Backend::GetOrderDetails.new(options) }
  let(:options) { { order_number: '5028575' } }
  
  include_examples 'configuration'
  
  it { is_expected.to be_a_kind_of(Wirecard::Backend::GetOrderDetails) }
  
  describe '#implicit_fingerprint_order' do
    subject { get_order_details.implicit_fingerprint_order }

    it { is_expected.to eq([:customer_id, :shop_id, :password, :secret, :language, :order_number]) }
  end

  describe '#defaults' do
    subject { get_order_details.defaults }

    include_examples 'Wirecard::Base#defaults'
  end
  
  describe '#url' do
    subject { get_order_details.url }
    
    it { is_expected.to eq('https://checkout.wirecard.com/seamless/backend/getorderdetails') }
  end
  
  describe '#post' do
    subject { get_order_details.post }
    include_examples 'stub requests'
    
    #before { WebMock.disable! }

    context 'when order_ident is given' do
      it { is_expected.to eq ({x: 'y'}) }
    end

    # context 'when order_ident is missing' do
#       let(:options) { Hash.new }
#
#       it { is_expected.to eq ({x: 'z'}) }
#     end
  end
end
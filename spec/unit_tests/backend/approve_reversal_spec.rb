require 'spec_helper'

RSpec.describe Wirecard::Backend::ApproveReversal do
  
  let(:approve_reversal) { Wirecard::Backend::ApproveReversal.new(options) }
  let(:options) { Hash.new.merge(order_number) }
  let(:order_number) { { order_number: '23473341' } }
  
  include_context 'configuration'
  
  it { is_expected.to be_a_kind_of(Wirecard::Backend::ApproveReversal) }
  
  describe '#implicit_fingerprint_order' do
    subject { approve_reversal.implicit_fingerprint_order }

    it { is_expected.to eq([:customer_id, :shop_id, :password, :secret, :language, :order_number]) }
  end

  describe '#defaults' do
    subject { approve_reversal.defaults }

    include_examples 'Wirecard::Base#defaults'
    include_examples 'Wirecard::Backend::Base#defaults'
  end

  describe '#url' do
    subject { approve_reversal.url }

    it { is_expected.to eq('https://checkout.wirecard.com/seamless/backend/approvereversal') }
  end

  describe '#post' do
    subject { approve_reversal.post }
    include_context 'stub requests'
    
    context 'when order number is 23473341' do
      let(:order_number) { { order_number: '23473341' } }

      #it { is_expected.to eq({ status: '0' }) }
    end

    context 'when order number is not given' do
      let(:order_number) { {  } }
      
      it { is_expected.to eq({
        :"error.1.consumer_message" => "Order number is missing.",
        :"error.1.error_code" => "11011",
        :"error.1.message" => "Order number is missing.",
        errors: "1",
        status: "1"
      }) }
    end
  end
end
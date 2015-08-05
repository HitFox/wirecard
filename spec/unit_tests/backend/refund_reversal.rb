require 'spec_helper'

RSpec.describe Wirecard::Backend::RefundReversal do
  
  let(:refund_reversal) { Wirecard::Backend::RefundReversal.new(options) }
  let(:options) { Hash.new.merge(order_number).merge(credit_number) }
  let(:order_number) { { order_number: '23473341' } }
  let(:credit_number) { { credit_number: '14949449'} }
  
  include_context 'configuration'
  
  it { is_expected.to be_a_kind_of(Wirecard::Backend::RefundReversal) }
  
  describe '#implicit_fingerprint_order' do
    subject { refund_reversal.implicit_fingerprint_order }

    it { is_expected.to eq([:customer_id, :shop_id, :password, :secret, :language, :order_number, :credit_number]) }
  end

  describe '#defaults' do
    subject { refund_reversal.defaults }

    include_examples 'Wirecard::Base#defaults'
    include_examples 'Wirecard::Backend::Base#defaults'
  end
  
  describe '#url' do
    subject { refund_reversal.url }
    
    it { is_expected.to eq('https://checkout.wirecard.com/seamless/backend/refundreversal') }
  end
  
  describe '#post' do
    subject { refund_reversal.post.response }
    include_context 'stub requests'
    
    context 'when required parameters are given' do
      let(:order_number) { { order_number: '23473341' } }
      let(:credit_number) { { credit_number: '14949449'} }
      
      it { is_expected.to eq({ status: "0" }) }
      
      context 'when required parameters are not given' do
        let(:order_number) { Hash.new }
        let(:credit_number) { Hash.new }
        
        it { is_expected.to eq({
           :"error.1.consumer_message" => "Order number is missing.",
           :"error.1.error_code" => "11011",
           :"error.1.message" => "Order number is missing.",
           :"error.2.consumer_message" => "Credit number is missing.",
           :"error.2.error_code" => "11013",
           :"error.2.message" => "Credit number is missing.",
           errors: "2",
           status: "1"
           }) }
      end
    end
  end
end
require 'spec_helper'

RSpec.describe Wirecard::Backend::DepositReversal do
  
  let(:deposit_reversal) { Wirecard::Backend::DepositReversal.new(options) }
  let(:options) { Hash.new.merge(order_number).merge(payment_number) }
  let(:order_number) { { order_number: '23473341' } }
  let(:payment_number) { { payment_number: '23473341'} }
  
  include_context 'configuration'
  
  it { is_expected.to be_a_kind_of(Wirecard::Backend::DepositReversal) }
  
  describe '#implicit_fingerprint_order' do
    subject { deposit_reversal.implicit_fingerprint_order }

    it { is_expected.to eq([:customer_id, :shop_id, :password, :secret, :language, :order_number, :payment_number]) }
  end

  describe '#defaults' do
    subject { deposit_reversal.defaults }

    include_examples 'Wirecard::Base#defaults'
    include_examples 'Wirecard::Backend::Base#defaults'
  end
  
  describe '#url' do
    subject { deposit_reversal.url }
    
    it { is_expected.to eq('https://checkout.wirecard.com/seamless/backend/depositreversal') }
  end
  
  describe '#post' do
    subject { deposit_reversal.post.response }
    include_context 'stub requests'
    
    context 'when order number is 23473341' do
      let(:order_number) { { order_number: '23473341' } }
      
      context 'when payment_number is given' do
        let(:payment_number) { { payment_number: '23473341'} }
        
        it { is_expected.to eq({ status: '0' }) }
      end
      
      context 'when payment_number is not given' do
        let(:payment_number) { {  } }
        
        it { is_expected.to eq({
          :"error.1.consumer_message" => "Payment number is missing.",
          :"error.1.error_code" => "11012",
          :"error.1.message" => "Payment number is missing.",
          errors: "1",
          status: "1"
        }) }
      end
    end
    
    context 'when order number is not given' do
      let(:order_number) { {  } }
      
      
      context 'when payment_number is given' do
        let(:payment_number) { { payment_number: '23473341'} }
        
        it { is_expected.to eq({
          :"error.1.consumer_message" => "Order number is missing.",
          :"error.1.error_code" => "11011",
          :"error.1.message" => "Order number is missing.",
          errors: "1",
          status: "1"
        }) }
      end
      
      context 'when payment_number is not given' do
        let(:payment_number) { {  } }
        
        it { is_expected.to eq({
          :"error.1.consumer_message" => "Order number is missing.",
          :"error.1.error_code" => "11011",
          :"error.1.message" => "Order number is missing.",
          :"error.2.consumer_message" => "Payment number is missing.",
          :"error.2.error_code" => "11012",
          :"error.2.message" => "Payment number is missing.",
          errors: "2",
          status: "1"
        }) }
      end
    end
  end
end
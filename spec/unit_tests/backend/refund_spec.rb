require 'spec_helper'

RSpec.describe Wirecard::Backend::Refund do
  
  let(:refund) { Wirecard::Backend::Refund.new(options) }
  let(:options) { Hash.new.merge(order_number).merge(amount).merge(currency) }
  let(:order_number) { { order_number: '23473341' } }
  let(:amount) { { amount: '1000'} }
  let(:currency) { { currency: 'EUR' } }
  
  include_context 'configuration'
  
  it { is_expected.to be_a_kind_of(Wirecard::Backend::Refund) }
  
  describe '#implicit_fingerprint_order' do
    subject { refund.implicit_fingerprint_order }

    it { is_expected.to eq([:customer_id, :shop_id, :password, :secret, :language, :order_number, :amount, :currency]) }
  end

  describe '#defaults' do
    subject { refund.defaults }

    include_examples 'Wirecard::Base#defaults'
    include_examples 'Wirecard::Backend::Base#defaults'
  end
  
  describe '#url' do
    subject { refund.url }
    
    it { is_expected.to eq('https://checkout.wirecard.com/seamless/backend/refund') }
  end
  
  describe '#post' do
    subject { refund.post.response }
    include_context 'stub requests'
    
    context 'when required parameters are given' do
      let(:order_number) { { order_number: '23473341' } }
      let(:amount) { { amount: '1000'} }
      let(:currency) { { currency: 'EUR' } }
       
      it { is_expected.to eq({ credit_number: "14949449", status: "0" }) }
      
      context 'when required parameters are not given' do
        let(:order_number) { Hash.new }
        let(:amount) { Hash.new }
        let(:currency) { Hash.new }
        
        it { is_expected.to eq({
           :"error.1.consumer_message" => "Order number is missing.",
           :"error.1.error_code" => "11011",
           :"error.1.message" => "Order number is missing.",
           :"error.2.consumer_message" => "Currency is missing.",
           :"error.2.error_code" => "11019",
           :"error.2.message" => "Currency is missing.",
           :"error.3.consumer_message" => "Amount is missing.",
           :"error.3.error_code" => "11017",
           :"error.3.message" => "Amount is missing.",
           errors: "3",
           status: "1"
           }) }
      end
    end
  end
end
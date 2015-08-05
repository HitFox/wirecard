require 'spec_helper'

RSpec.describe Wirecard::Backend::Deposit do
  
  let(:deposit) { Wirecard::Backend::Deposit.new(options) }
  let(:options) { Hash.new.merge(order_number).merge(amount).merge(currency) }
  let(:order_number) { { order_number: '23473341' } }
  let(:amount) { { amount: '1000'} }
  let(:currency) { { currency: 'EUR' } }
  
  include_context 'configuration'
  
  it { is_expected.to be_a_kind_of(Wirecard::Backend::Deposit) }
  
  describe '#implicit_fingerprint_order' do
    subject { deposit.implicit_fingerprint_order }

    it { is_expected.to eq([:customer_id, :shop_id, :password, :secret, :language, :order_number, :amount, :currency]) }
  end

  describe '#defaults' do
    subject { deposit.defaults }

    include_examples 'Wirecard::Base#defaults'
    include_examples 'Wirecard::Backend::Base#defaults'
  end
  
  describe '#url' do
    subject { deposit.url }
    
    it { is_expected.to eq('https://checkout.wirecard.com/seamless/backend/deposit') }
  end
  
  describe '#post' do
    subject { deposit.post.response }
    include_context 'stub requests'
    
    context 'when order number is 23473341' do
      let(:order_number) { { order_number: '23473341' } }
      
      it { is_expected.to eq({ payment_number: "23473341", status: "0" }) }
      
      context 'when amount is not given' do
        let(:amount) { {} }
        
        it { is_expected.to eq({
            :"error.1.consumer_message" => "Amount is missing.",
            :"error.1.error_code" => "11017",
            :"error.1.message" => "Amount is missing.",
            errors: "1",
            status: "1"
           }) }
      end
      
      context 'when currency is not given' do
        let(:currency) { {} }
        
        it { is_expected.to eq({
            :"error.1.consumer_message" => "Currency is missing.",
            :"error.1.error_code" => "11019",
            :"error.1.message" => "Currency is missing.",
            errors: "1",
            status: "1"
           }) }
      end
    end
    context 'when order number is not given' do
      let(:order_number) { {} }
      
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
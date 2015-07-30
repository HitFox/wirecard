require 'spec_helper'

RSpec.describe Wirecard::Backend::RecurPayment do
  
  let(:recur_payment) { Wirecard::Backend::RecurPayment.new(options) }
  let(:options) { Hash.new.merge(amount).merge(currency).merge(order_description).merge(source_order_number).merge(auto_deposit).merge(customer_statement).merge(order_number).merge(order_reference) }
  let(:amount) { { amount: '1000'} }
  let(:currency) { { currency: 'EUR' } }
  let(:order_description) { { order_description: 'some description'} }
  let(:source_order_number) { { source_order_number: '23473341'} }
  let(:auto_deposit) { { auto_deposit: 'Yes' } }
  let(:customer_statement) { { customer_statement: 'some statement' } }
  let(:order_number) { { order_number: '23473341' } }
  let(:order_reference) { { order_reference: 'MercantID_X345456' } }
  
  include_context 'configuration'
  
  it { is_expected.to be_a_kind_of(Wirecard::Backend::RecurPayment) }
  
  describe '#implicit_fingerprint_order' do
    subject { recur_payment.implicit_fingerprint_order }

    it { is_expected.to eq([:customer_id, :shop_id, :password, :secret, :language, :order_number, :source_order_number, :auto_deposit, :order_description, :amount, :currency, :order_reference, :customer_statement]) }
  end

  describe '#defaults' do
    subject { recur_payment.defaults }

    include_examples 'Wirecard::Base#defaults'
    include_examples 'Wirecard::Backend::Base#defaults'
  end
  
  describe '#url' do
    subject { recur_payment.url }
    
    it { is_expected.to eq('https://checkout.wirecard.com/seamless/backend/recurpayment') }
  end
  
  describe '#post' do
    subject { recur_payment.post }
    include_context 'stub requests'
    
    context 'when required parameters are given' do
      let(:amount) { { amount: '1000'} }
      let(:currency) { { currency: 'EUR' } }
      let(:order_description) { { order_description: 'some description'} }
      let(:source_order_number) { { source_order_number: '23473341'} }
      
      it { is_expected.to eq({ order_number: "23473341", status: "0" }) }
      
      context 'when required parameters are not given' do
        let(:amount) { Hash.new }
        let(:currency) { Hash.new }
        let(:order_description) { Hash.new }
        let(:source_order_number) { Hash.new }
        
        it { is_expected.to eq({
           :"error.1.consumer_message" => "Source ORDERNUMBER is missing.",
           :"error.1.error_code" => "11159",
           :"error.1.message" => "Source ORDERNUMBER is missing.",
           :"error.2.consumer_message" => "Order description is missing.",
           :"error.2.error_code" => "11020",
           :"error.2.message" => "Order description is missing.",
           :"error.3.consumer_message" => "Amount is missing.",
           :"error.3.error_code" => "11017",
           :"error.3.message" => "Amount is missing.",
           :"error.4.consumer_message" => "Currency is missing.",
           :"error.4.error_code" => "11019",
           :"error.4.message" => "Currency is missing.",
           errors: "4",
           status: "1"
           }) }
      end
      
      context 'when optional parameters are not given' do
        let(:auto_deposit) { Hash.new }
        let(:customer_statement) { Hash.new }
        let(:order_number) { Hash.new }
        let(:order_reference) { Hash.new }
        
        it { is_expected.to eq({ order_number: "23473341", status: "0" }) }
      end
      
    end
  end
end
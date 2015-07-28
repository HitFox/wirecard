require 'spec_helper'

RSpec.describe Wirecard::PaymentProcess::Init do
  
  let(:init) { Wirecard::PaymentProcess::Init.new(options) }
  let(:options) { { payment_type: 'CCARD',
                    amount: '1000',
                    consumer_ip_address: '127.0.0.1',
                    consumer_user_agent: 'some agent',
                    currency: 'USD',
                    language: 'en',
                    order_description: 'some description' } }
  
  include_examples 'configuration'
  
  it { is_expected.to be_a_kind_of(Wirecard::PaymentProcess::Init) }
  
  describe '#implicit_fingerprint_order' do
    subject { init.implicit_fingerprint_order }

    it { is_expected.to be nil }
  end

  describe '#defaults' do
    subject { init.defaults }

    include_examples 'Wirecard::Base#defaults'
    it { expect(subject[:language]).to eq(config[:language]) }
    it { expect(subject[:currency]).to eq(config[:currency]) }
    it { expect(subject[:success_url]).to eq(config[:success_url]) }
    it { expect(subject[:failure_url]).to eq(config[:failure_url]) }
    it { expect(subject[:cancel_url]).to eq(config[:cancel_url]) }
    it { expect(subject[:service_url]).to eq(config[:service_url]) }
    it { expect(subject[:confirm_url]).to eq(config[:confirm_url]) }
  end
  
  describe '#url' do
    subject { init.url }
    
    it { is_expected.to eq('https://checkout.wirecard.com/seamless/frontend/init') }
  end
  
  describe '#post' do
    subject { init.post }
    include_examples 'stub requests'

    context 'when options are valid' do
      it { is_expected.to eq ({redirect_url: "https://checkout.wirecard.com/seamless/frontend/D200001qmore_DESKTOP/select.php?SID=ttkbc64otkqk067oca49ft0cr5" } ) }
    end

    context 'when options are invalid' do
      let(:options) { Hash.new }

      it { is_expected.to eq ({
         :"error.1.consumer_message" => "PAYMENTTYPE is missing.",
         :"error.1.error_code" => "11051",
         :"error.1.message" => "PAYMENTTYPE is missing.",
         :"error.2.consumer_message" => "Currency is missing.",
         :"error.2.error_code" => "11019",
         :"error.2.message" => "Currency is missing.",
         :"error.3.consumer_message" => "Order description is missing.",
         :"error.3.error_code" => "11020",
         :"error.3.message" => "Order description is missing.",
         :"error.4.consumer_message" => "Amount is missing.",
         :"error.4.error_code" => "11017",
         :"error.4.message" => "Amount is missing.",
         :"error.5.consumer_message" => "IP-Address is missing.",
         :"error.5.error_code" => "11146",
         :"error.5.message" => "IP-Address is missing.",
         :"error.6.consumer_message" => "USER_AGENT is missing.",
         :"error.6.error_code" => "11130",
         :"error.6.message" => "USER_AGENT is missing.",
         errors: "6"}) }
    end
  end
end
require 'spec_helper'

RSpec.describe Wirecard::PaymentProcess::Init do

  let(:init) { Wirecard::PaymentProcess::Init.new(options) }
  let(:options) { Hash.new.merge(payment_type_data).merge(payment_data).merge(consumer_data) }
  let(:payment_type_data) { { payment_type: 'CCARD', storage_id: 'b2737b746627482e0b024097cadb1b41' } }
  let(:payment_data) { { amount: '1000', currency: 'USD', order_description: 'some description' } }
  let(:consumer_data) { { consumer_ip_address: '127.0.0.1', consumer_user_agent: 'some agent', language: 'en'} }

  include_context 'configuration'
  include_context 'stub requests'

  it { is_expected.to be_a_kind_of(Wirecard::PaymentProcess::Init) }

  describe '#implicit_fingerprint_order' do
    subject { init.implicit_fingerprint_order }

    it { is_expected.to be nil }
  end

  describe '#defaults' do
    subject { init.defaults }

    include_examples 'Wirecard::Base#defaults'
    it { expect(subject[:order_number]).to eq(1113051) }
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
    subject { init.post.response }

    context 'when credit card payment' do
      let(:payment_type_data) { { payment_type: 'CCARD', storage_id: 'b2737b746627482e0b024097cadb1b41' } }

      it { is_expected.to eq ({redirect_url: "https://checkout.wirecard.com/seamless/frontend/D200001qmore_DESKTOP/select.php?SID=ttkbc64otkqk067oca49ft0cr5" } ) }
    end

    context 'when Sofortüberweisung payment' do
      let(:payment_type_data) { { payment_type: 'SOFORTUEBERWEISUNG' } }

      it { is_expected.to eq ({redirect_url: "https://checkout.wirecard.com/seamless/frontend/D200001qmore_DESKTOP/select.php?SID=ckovh2titpm7kagm48e532ifc6" } ) }
    end

    context 'when SEPA payment' do
      let(:payment_type_data) { { payment_type: 'SEPA-DD' } }

      it { is_expected.to eq ({redirect_url: "https://checkout.wirecard.com/seamless/frontend/D200001qmore_DESKTOP/select.php?SID=j5bk04off945jg6qv25imb1en4" } ) }
    end

    context 'when PayPal payment' do
      let(:payment_type_data) { { payment_type: 'PAYPAL' } }

      it { is_expected.to eq ({redirect_url: "https://checkout.wirecard.com/seamless/frontend/D200001qmore_DESKTOP/select.php?SID=1ccoq6lf3euji7dk018sulomg6" } ) }
    end

    context 'when options are invalid' do
      subject { Wirecard::PaymentProcess::Init.new(Hash.new).post.response }
      #let(:options) { Hash.new }

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
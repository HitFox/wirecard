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

    context 'when order number is 23473341' do
      let(:order_number) { { order_number: '23473341' } }

      context 'when payment_number is given' do
        let(:payment_number) { { payment_number: '23473341'} }

        before do
          stub_request(:post, "https://checkout.wirecard.com/seamless/backend/depositreversal").
            with(body: default_backend_request_hash.merge(
              {
                "orderNumber"=>"23473341",
                "paymentNumber"=>'23473341',
                "requestFingerprint"=>"51b6ba02b404a79a3ae20b60d8f37c8756be90940e6b7ee5f1399eb541ad26839b06a880959a6837cad9c694b8f44974a8855e5cbdc04cd95337352f2cd53f12"
              }
            )).
            to_return(
              status: 200,
              body: "status=0",
              headers: {}
            )
        end

        it { is_expected.to eq({ status: '0' }) }
      end

      context 'when payment_number is not given' do
        let(:payment_number) { {  } }

        before do
          stub_request(:post, "https://checkout.wirecard.com/seamless/backend/depositreversal").
            with(body: default_backend_request_hash.merge(
              {
                "orderNumber"=>"23473341",
                "requestFingerprint"=>"4b5b4733bf2ec86456f180a75ed08eb7c0d3abbe8b3f834f313a5f35b8fe85fdf9568765f08cf8921be864764585d85a12357b9826e0f197255d69afc4155a45"
              }
            )).
            to_return(
              status: 200,
              body: "error.1.errorCode=11012&error.1.message=Payment+number+is+missing.&error.1.consumerMessage=Payment+number+is+missing.&errors=1&status=1",
              headers: {}
            )
        end

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

        before do
          stub_request(:post, "https://checkout.wirecard.com/seamless/backend/depositreversal").
            with(body: default_backend_request_hash.merge(
              {
                "paymentNumber"=>'23473341',
                "requestFingerprint"=>"4b5b4733bf2ec86456f180a75ed08eb7c0d3abbe8b3f834f313a5f35b8fe85fdf9568765f08cf8921be864764585d85a12357b9826e0f197255d69afc4155a45"
              }
            )).
            to_return(
              status: 200,
              body: "error.1.errorCode=11011&error.1.message=Order+number+is+missing.&error.1.consumerMessage=Order+number+is+missing.&errors=1&status=1",
              headers: {}
            )
        end

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

        before do
          stub_request(:post, "https://checkout.wirecard.com/seamless/backend/depositreversal").
            with(body: default_backend_request_hash.merge(
              {
                "requestFingerprint"=>"dfd315b6687aa1f213450008cb3932b29c23601097a0f1a120377938149c3be84e54dafd36e7cf75385e6f356cff79f1a084712d099bedeb2735e63df861b2c5"
              }
            )).
            to_return(
              status: 200,
              body: "error.1.errorCode=11011&error.1.message=Order+number+is+missing.&error.1.consumerMessage=Order+number+is+missing.&error.2.errorCode=11012&error.2.message=Payment+number+is+missing.&error.2.consumerMessage=Payment+number+is+missing.&errors=2&status=1",
              headers: {}
            )
        end

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
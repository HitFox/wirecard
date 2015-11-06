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

    context 'when required parameters are given' do
      let(:order_number) { { order_number: '23473341' } }
      let(:amount) { { amount: '1000'} }
      let(:currency) { { currency: 'EUR' } }

      before do
        stub_request(:post, "https://checkout.wirecard.com/seamless/backend/refund").
          with(body: default_backend_request_hash.merge(
            {
              "amount"=>"1000",
              "currency"=>"EUR",
              "orderNumber"=>"23473341",
              "requestFingerprint"=>"db96723ef9e69e323a63d65f634c03badaa7e373f8ca65f1e764162464e28414e476072aca98b7ae2aee7dd045b52abd102b3f74b3a6d72223ca51f105368792"
            }
          )).
          to_return(
            status: 200,
            body: "creditNumber=14949449&status=0",
            headers: {}
          )
      end

      it { is_expected.to eq({ credit_number: "14949449", status: "0" }) }

      context 'when required parameters are not given' do
        let(:order_number) { Hash.new }
        let(:amount) { Hash.new }
        let(:currency) { Hash.new }

        before do
          stub_request(:post, "https://checkout.wirecard.com/seamless/backend/refund").
            with(body: default_backend_request_hash.merge(
              {
                "requestFingerprint"=>"dfd315b6687aa1f213450008cb3932b29c23601097a0f1a120377938149c3be84e54dafd36e7cf75385e6f356cff79f1a084712d099bedeb2735e63df861b2c5"
              }
            )).
            to_return(
              status: 200,
              body: "error.1.errorCode=11011&error.1.message=Order+number+is+missing.&error.1.consumerMessage=Order+number+is+missing.&error.2.errorCode=11019&error.2.message=Currency+is+missing.&error.2.consumerMessage=Currency+is+missing.&error.3.errorCode=11017&error.3.message=Amount+is+missing.&error.3.consumerMessage=Amount+is+missing.&errors=3&status=1",
              headers: {}
            )
        end

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
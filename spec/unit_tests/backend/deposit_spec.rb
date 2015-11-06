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

    context 'when order number is 23473341' do
      let(:order_number) { { order_number: '23473341' } }

      before do
        stub_request(:post, "https://checkout.wirecard.com/seamless/backend/deposit").
          with(body: default_backend_request_hash.merge(
            {
              "amount"=>'1000',
              "currency"=>'EUR',
              "orderNumber"=>"23473341",
              "requestFingerprint"=>"db96723ef9e69e323a63d65f634c03badaa7e373f8ca65f1e764162464e28414e476072aca98b7ae2aee7dd045b52abd102b3f74b3a6d72223ca51f105368792"
            }
          )).
          to_return(
            status: 200,
            body: "paymentNumber=23473341&status=0",
            headers: {}
          )
      end

      it { is_expected.to eq({ payment_number: "23473341", status: "0" }) }

      context 'when amount is not given' do
        let(:amount) { {} }

        before do
          stub_request(:post, "https://checkout.wirecard.com/seamless/backend/deposit").
            with(body: default_backend_request_hash.merge(
              {
                "currency"=>'EUR',
                "orderNumber"=>"23473341",
                "requestFingerprint"=>"8f998a36a3060d88970dd90b648aafec16ecc11db82c60f84dd636e1bb0a976b11a93b5f204d84e426356c6c0bdad8514c954e56ad351fcbcb12c5484cc6002f"
              }
            )).
            to_return(
              status: 200,
              body: "error.1.errorCode=11017&error.1.message=Amount+is+missing.&error.1.consumerMessage=Amount+is+missing.&errors=1&status=1",
              headers: {}
            )
        end

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

        before do
          stub_request(:post, "https://checkout.wirecard.com/seamless/backend/deposit").
            with(body: default_backend_request_hash.merge(
              {
                "amount"=>'1000',
                "orderNumber"=>"23473341",
                "requestFingerprint"=>"fbd960f2ed92db219ee1c85790bda0b7c591e0d7b004d8cf1a4a554f112b33a02ee13203e62d53395f80dbc10c6b98f070dbb5b03084387deacc3689f8143753"
              }
            )).
            to_return(
              status: 200,
              body: "error.1.errorCode=11019&error.1.message=Currency+is+missing.&error.1.consumerMessage=Currency+is+missing.&errors=1&status=1",
              headers: {}
            )
        end

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

      before do
        stub_request(:post, "https://checkout.wirecard.com/seamless/backend/deposit").
          with(body: default_backend_request_hash.merge(
            {
              "amount"=>'1000',
              "currency"=>'EUR',
              "requestFingerprint"=>"85482e191e98ba78be9699348a51a0b848efafe60d7afc3cb091ad33cf0fb487838096540bbf3c7201b4c9bd0a1a897a5d9e3b440243cc2ee5a22114d585ddf5"
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
  end
end
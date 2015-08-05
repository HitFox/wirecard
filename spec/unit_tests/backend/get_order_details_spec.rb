require 'spec_helper'

RSpec.describe Wirecard::Backend::GetOrderDetails do
  
  let(:get_order_details) { Wirecard::Backend::GetOrderDetails.new(options) }
  let(:options) { { order_number: '23473341' } }
  
  include_context 'configuration'
  
  it { is_expected.to be_a_kind_of(Wirecard::Backend::GetOrderDetails) }
  
  describe '#implicit_fingerprint_order' do
    subject { get_order_details.implicit_fingerprint_order }

    it { is_expected.to eq([:customer_id, :shop_id, :password, :secret, :language, :order_number]) }
  end

  describe '#defaults' do
    subject { get_order_details.defaults }

    include_examples 'Wirecard::Base#defaults'
    include_examples 'Wirecard::Backend::Base#defaults'
  end
  
  describe '#url' do
    subject { get_order_details.url }
    
    it { is_expected.to eq('https://checkout.wirecard.com/seamless/backend/getorderdetails') }
  end
  
  describe '#post' do
    subject { get_order_details.post.response }
    include_context 'stub requests'

    context 'when order_number is given' do
      context 'when order number refers is 23473341 (VISA)' do
        let(:options) { { order_number: '23473341' } }
        
        it { is_expected.to eq ( {
          objects_total: "1",
          :"order.1.acquirer" => "card complete",
          :"order.1.amount" => "1.00",
          :"order.1.approve_amount" => "1.00",
          :"order.1.brand" => "VISA",
          :"order.1.contract_number" => "0815DemoContract",
          :"order.1.credits" => "0",
          :"order.1.currency" => "EUR",
          :"order.1.customer_statement" => "Danke für den Einkauf!",
          :"order.1.deposit_amount" => "0",
          :"order.1.merchant_number" => "1",
          :"order.1.order_description" => "Lisa Kaufrausch, K-Nr: 54435",
          :"order.1.order_number" => "23473341",
          :"order.1.order_reference" => "OR-23473341",
          :"order.1.payment_type" => "VPG",
          :"order.1.payments" => "1",
          :"order.1.refund_amount" => "0",
          :"order.1.state" => "ORDERED",
          :"order.1.time_created" => "30.07.2015 10:52:53",
          :"order.1.time_modified" => "30.07.2015 10:52:53",
          orders: "1",
          :"payment.1.1.approval_code" => "123456",
          :"payment.1.1.approve_amount" => "1.00",
          :"payment.1.1.currency" => "EUR",
          :"payment.1.1.deposit_amount" => "0.00",
          :"payment.1.1.merchant_number" => "1",
          :"payment.1.1.operations_allowed" => "DEPOSIT,APPROVEREVERSAL",
          :"payment.1.1.order_number" => "23473341",
          :"payment.1.1.payment_number" => "23473341",
          :"payment.1.1.payment_type" => "VPG",
          :"payment.1.1.state" => "payment_approved",
          :"payment.1.1.time_created" => "30.07.2015 10:52:53",
          :"payment.1.1.time_modified" => "30.07.2015 10:52:53",
            status: "0"
          }) }
      end

      context 'when order number refers is 56453412 (Mastercard)' do
        let(:options) { { order_number: '56453412' } }

        it { is_expected.to eq ( {
          objects_total: "1",
          :"order.1.acquirer" => "PayLife",
          :"order.1.amount" => "1.00",
          :"order.1.approve_amount" => "1.00",
          :"order.1.brand" => "MasterCard",
          :"order.1.contract_number" => "0815DemoContract",
          :"order.1.credits" => "0",
          :"order.1.currency" => "EUR",
          :"order.1.customer_statement" => "Danke für den Einkauf!",
          :"order.1.deposit_amount" => "0",
          :"order.1.merchant_number" => "1",
          :"order.1.order_description" => "Max Mustermann, K-Nr: 12345",
          :"order.1.order_number" => "56453412",
          :"order.1.order_reference" => "OR-56453412",
          :"order.1.payment_type" => "APG",
          :"order.1.payments" => "1",
          :"order.1.refund_amount" => "0",
          :"order.1.state" => "ORDERED",
          :"order.1.time_created" => "30.07.2015 11:20:53",
          :"order.1.time_modified" => "30.07.2015 11:20:53",
          orders: "1",
          :"payment.1.1.approval_code" => "123456",
          :"payment.1.1.approve_amount" => "1.00",
          :"payment.1.1.currency" => "EUR",
          :"payment.1.1.deposit_amount" => "0.00",
          :"payment.1.1.merchant_number" => "1",
          :"payment.1.1.operations_allowed" => "DEPOSIT,APPROVEREVERSAL",
          :"payment.1.1.order_number" => "56453412",
          :"payment.1.1.payment_number" => "56453412",
          :"payment.1.1.payment_type" => "APG",
          :"payment.1.1.state" => "payment_approved",
          :"payment.1.1.time_created" => "30.07.2015 11:20:53",
          :"payment.1.1.time_modified" => "30.07.2015 11:20:53",
            status: "0"
          }) }
      end
      
      context 'when order number is 543132154 (Sofortüberweisung)' do
        let(:options) { { order_number: '543132154' } }
        
        it { is_expected.to eq ( {
           objects_total: "1",
           :"order.1.amount" => "1.00",
           :"order.1.approve_amount" => "0",
           :"order.1.brand" => "sofortueberweisung",
           :"order.1.contract_number" => "1234/1234",
           :"order.1.credits" => "0",
           :"order.1.currency" => "EUR",
           :"order.1.customer_statement" => "Danke für den Einkauf!",
           :"order.1.deposit_amount" => "1.00",
           :"order.1.merchant_number" => "1",
           :"order.1.order_description" => "F. Realtime, K-Nr: 12111",
           :"order.1.order_number" => "543132154",
           :"order.1.order_reference" => "OR-543132154",
           :"order.1.payment_type" => "SUE",
           :"order.1.payments" => "1",
           :"order.1.refund_amount" => "0",
           :"order.1.state" => "ORDERED",
           :"order.1.time_created" => "30.07.2015 11:32:49",
           :"order.1.time_modified" => "30.07.2015 11:32:49",
           orders: "1",
           :"payment.1.1.approval_code" => "00000-00000-AAAAAAAA-BBBB",
           :"payment.1.1.approve_amount" => "1.00",
           :"payment.1.1.batch_number" => "131",
           :"payment.1.1.currency" => "EUR",
           :"payment.1.1.deposit_amount" => "1.00",
           :"payment.1.1.merchant_number" => "1",
           :"payment.1.1.order_number" => "543132154",
           :"payment.1.1.payment_number" => "543132154",
           :"payment.1.1.payment_type" => "SUE",
           :"payment.1.1.security_criteria" => "1",
           :"payment.1.1.sender_account_number" => "1234567890",
           :"payment.1.1.sender_account_owner" => "Test Consumer",
           :"payment.1.1.sender_b_i_c" => "PNAGDE00000",
           :"payment.1.1.sender_bank_name" => "Test Bank",
           :"payment.1.1.sender_bank_number" => "1234578",
           :"payment.1.1.sender_country" => "DE",
           :"payment.1.1.sender_i_b_a_n" => "DE0000000000000000",
           :"payment.1.1.state" => "payment_deposited",
           :"payment.1.1.time_created" => "30.07.2015 11:32:49",
           :"payment.1.1.time_modified" => "30.07.2015 11:32:49",
           status: "0"
          }) }
      end
      
      context 'when order number is 3485464 (PayPal)' do
        let(:options) { { order_number: '3485464' } }
        
        it { is_expected.to eq({
           objects_total: "1",
           :"order.1.amount" => "1.00",
           :"order.1.approve_amount" => "0",
           :"order.1.brand" => "PayPal",
           :"order.1.contract_number" => "mail@shop.com",
           :"order.1.credits" => "0",
           :"order.1.currency" => "EUR",
           :"order.1.customer_statement" => "Danke für den Einkauf!",
           :"order.1.deposit_amount" => "1.00",
           :"order.1.merchant_number" => "1",
           :"order.1.order_description" => "E. Bay, K-Nr: 55266",
           :"order.1.order_number" => "3485464",
           :"order.1.order_reference" => "OR-3485464",
           :"order.1.payment_type" => "PPL",
           :"order.1.payments" => "1",
           :"order.1.refund_amount" => "0",
           :"order.1.state" => "ORDERED",
           :"order.1.time_created" => "30.07.2015 11:41:37",
           :"order.1.time_modified" => "30.07.2015 11:41:37",
           orders: "1",
           :"payment.1.1.approval_code" => "4PW61566G53703003",
           :"payment.1.1.approve_amount" => "1.00",
           :"payment.1.1.batch_number" => "129",
           :"payment.1.1.currency" => "EUR",
           :"payment.1.1.deposit_amount" => "1.00",
           :"payment.1.1.merchant_number" => "1",
           :"payment.1.1.order_number" => "3485464",
           :"payment.1.1.payment_number" => "3485464",
           :"payment.1.1.payment_type" => "PPL",
           :"payment.1.1.paypal_payer_address_city" => "Musterstadt",
           :"payment.1.1.paypal_payer_address_country" => "AT",
           :"payment.1.1.paypal_payer_address_state" => "Musterland",
           :"payment.1.1.paypal_payer_address_status" => "unverified",
           :"payment.1.1.paypal_payer_address_z_i_p" => "1234",
           :"payment.1.1.paypal_payer_email" => "buyer@paypal.com",
           :"payment.1.1.paypal_payer_first_name" => "Test",
           :"payment.1.1.paypal_payer_i_d" => "PAYER123456ID",
           :"payment.1.1.paypal_payer_last_name" => "Consumer",
           :"payment.1.1.paypal_protection_eligibility" => "ExtendedCustomerProtection",
           :"payment.1.1.state" => "payment_deposited",
           :"payment.1.1.time_created" => "30.07.2015 11:41:37",
           :"payment.1.1.time_modified" => "30.07.2015 11:41:37",
           status: "0"
        }) }
      end
      
      context 'when order number is 123456789 (non-existing order)' do
        let(:options) { { order_number: '123456789' } }
        
        it { is_expected.to eq ({ objects_total: "0", orders: "0", status: "0" }) }
      end
    end

    context 'when order_number is missing' do
      let(:options) { Hash.new }

      it { is_expected.to eq ({:"error.1.consumer_message" => "Order number is missing.",
                               :"error.1.error_code" => "11011",
                               :"error.1.message" => "Order number is missing.",
                               errors: "1",
                               status: "1"}) }
    end
  end
end
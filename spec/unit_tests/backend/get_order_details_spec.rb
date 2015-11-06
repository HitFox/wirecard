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

    context 'when order_number is given' do
      context 'when order number refers is 23473341 (VISA)' do
        let(:options) { { order_number: '23473341' } }

        before do
          stub_request(:post, "https://checkout.wirecard.com/seamless/backend/getorderdetails").
            with(body: default_backend_request_hash.merge(
              {
                "orderNumber"=>"23473341",
                "requestFingerprint"=>"4b5b4733bf2ec86456f180a75ed08eb7c0d3abbe8b3f834f313a5f35b8fe85fdf9568765f08cf8921be864764585d85a12357b9826e0f197255d69afc4155a45"
              }
            )).
            to_return(
              status: 200,
              body: "payment.1.1.currency=EUR&payment.1.1.state=payment_approved&payment.1.1.orderNumber=23473341&payment.1.1.timeModified=30.07.2015+10%3A52%3A53&payment.1.1.merchantNumber=1&payment.1.1.timeCreated=30.07.2015+10%3A52%3A53&payment.1.1.depositAmount=0.00&payment.1.1.paymentType=VPG&payment.1.1.approvalCode=123456&payment.1.1.paymentNumber=23473341&payment.1.1.approveAmount=1.00&payment.1.1.operationsAllowed=DEPOSIT%2CAPPROVEREVERSAL&order.1.orderNumber=23473341&order.1.paymentType=VPG&order.1.brand=VISA&order.1.depositAmount=0&order.1.state=ORDERED&order.1.timeModified=30.07.2015+10%3A52%3A53&order.1.currency=EUR&order.1.contractNumber=0815DemoContract&order.1.orderDescription=Lisa+Kaufrausch%2C+K-Nr%3A+54435&order.1.payments=1&order.1.timeCreated=30.07.2015+10%3A52%3A53&order.1.orderReference=OR-23473341&order.1.refundAmount=0&order.1.acquirer=card+complete&order.1.customerStatement=Danke+f%C3%BCr+den+Einkauf%21&order.1.amount=1.00&order.1.credits=0&order.1.approveAmount=1.00&order.1.merchantNumber=1&objectsTotal=1&status=0&orders=1",
              headers: {}
            )
        end

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

        before do
          stub_request(:post, "https://checkout.wirecard.com/seamless/backend/getorderdetails").
            with(body: default_backend_request_hash.merge(
              {
                "orderNumber"=>"56453412",
                "requestFingerprint"=>"512954a4d75c781d02c36504fe51f170470af50e1438bd61e757ed21d262072d1e292a3df96c5c4a5fcce7fdb24b25be211346692175ec6ebe09f574f2e7d478"
              }
            )).
            to_return(
              status: 200,
              body: "payment.1.1.currency=EUR&payment.1.1.state=payment_approved&payment.1.1.orderNumber=56453412&payment.1.1.timeModified=30.07.2015+11%3A20%3A53&payment.1.1.merchantNumber=1&payment.1.1.timeCreated=30.07.2015+11%3A20%3A53&payment.1.1.depositAmount=0.00&payment.1.1.paymentType=APG&payment.1.1.approvalCode=123456&payment.1.1.paymentNumber=56453412&payment.1.1.approveAmount=1.00&payment.1.1.operationsAllowed=DEPOSIT%2CAPPROVEREVERSAL&order.1.orderNumber=56453412&order.1.paymentType=APG&order.1.brand=MasterCard&order.1.depositAmount=0&order.1.state=ORDERED&order.1.timeModified=30.07.2015+11%3A20%3A53&order.1.currency=EUR&order.1.contractNumber=0815DemoContract&order.1.orderDescription=Max+Mustermann%2C+K-Nr%3A+12345&order.1.payments=1&order.1.timeCreated=30.07.2015+11%3A20%3A53&order.1.orderReference=OR-56453412&order.1.refundAmount=0&order.1.acquirer=PayLife&order.1.customerStatement=Danke+f%C3%BCr+den+Einkauf%21&order.1.amount=1.00&order.1.credits=0&order.1.approveAmount=1.00&order.1.merchantNumber=1&objectsTotal=1&status=0&orders=1",
              headers: {}
            )
        end

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

        before do
          stub_request(:post, "https://checkout.wirecard.com/seamless/backend/getorderdetails").
            with(body: default_backend_request_hash.merge(
              {
                "orderNumber"=>"543132154",
                "requestFingerprint"=>"865d590cfa0b89587893ce64fb510977b1c49e81d47c6591c887a7470cc85828022034f262dbfcc8aadad6a2e269e4f85eb836427ece3699cf4d898364502dbb"
              }
            )).
            to_return(
              status: 200,
              body: "payment.1.1.currency=EUR&payment.1.1.state=payment_deposited&payment.1.1.senderAccountOwner=Test+Consumer&payment.1.1.timeModified=30.07.2015+11%3A32%3A49&payment.1.1.merchantNumber=1&payment.1.1.timeCreated=30.07.2015+11%3A32%3A49&payment.1.1.senderIBAN=DE0000000000000000&payment.1.1.depositAmount=1.00&payment.1.1.senderBIC=PNAGDE00000&payment.1.1.senderBankName=Test+Bank&payment.1.1.senderBankNumber=1234578&payment.1.1.approvalCode=00000-00000-AAAAAAAA-BBBB&payment.1.1.senderCountry=DE&payment.1.1.orderNumber=543132154&payment.1.1.paymentType=SUE&payment.1.1.securityCriteria=1&payment.1.1.paymentNumber=543132154&payment.1.1.approveAmount=1.00&payment.1.1.senderAccountNumber=1234567890&payment.1.1.batchNumber=131&order.1.brand=sofortueberweisung&order.1.paymentType=SUE&order.1.state=ORDERED&order.1.currency=EUR&order.1.orderDescription=F.+Realtime%2C+K-Nr%3A+12111&order.1.orderReference=OR-543132154&order.1.refundAmount=0&order.1.customerStatement=Danke+f%C3%BCr+den+Einkauf%21&order.1.orderNumber=543132154&order.1.depositAmount=1.00&order.1.timeModified=30.07.2015+11%3A32%3A49&order.1.contractNumber=1234%2F1234&order.1.payments=1&order.1.timeCreated=30.07.2015+11%3A32%3A49&order.1.amount=1.00&order.1.credits=0&order.1.approveAmount=0&order.1.merchantNumber=1&objectsTotal=1&status=0&orders=1",
              headers: {}
            )
        end

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

        before do
          stub_request(:post, "https://checkout.wirecard.com/seamless/backend/getorderdetails").
            with(body: default_backend_request_hash.merge(
              {
                "orderNumber"=>"3485464",
                "requestFingerprint"=>"c057221a6a402100f70f2ab519b71f047fe15d0e3b20d3777c0a6620682efde52c0902c321dca0185bd72f461acfc5634ecd6ab14c1791e316883a31d8560f42"
              }
            )).
            to_return(
              status: 200,
              body: "payment.1.1.currency=EUR&payment.1.1.state=payment_deposited&payment.1.1.timeModified=30.07.2015+11%3A41%3A37&payment.1.1.paypalPayerAddressStatus=unverified&payment.1.1.merchantNumber=1&payment.1.1.timeCreated=30.07.2015+11%3A41%3A37&payment.1.1.paypalPayerAddressState=Musterland&payment.1.1.depositAmount=1.00&payment.1.1.approvalCode=4PW61566G53703003&payment.1.1.paypalPayerAddressCountry=AT&payment.1.1.paypalPayerFirstName=Test&payment.1.1.orderNumber=3485464&payment.1.1.paypalPayerEmail=buyer%40paypal.com&payment.1.1.paypalPayerLastName=Consumer&payment.1.1.paymentType=PPL&payment.1.1.paypalPayerAddressCity=Musterstadt&payment.1.1.paypalPayerAddressZIP=1234&payment.1.1.paypalProtectionEligibility=ExtendedCustomerProtection&payment.1.1.paymentNumber=3485464&payment.1.1.approveAmount=1.00&payment.1.1.paypalPayerID=PAYER123456ID&payment.1.1.batchNumber=129&order.1.brand=PayPal&order.1.paymentType=PPL&order.1.state=ORDERED&order.1.currency=EUR&order.1.orderDescription=E.+Bay%2C+K-Nr%3A+55266&order.1.orderReference=OR-3485464&order.1.refundAmount=0&order.1.customerStatement=Danke+f%C3%BCr+den+Einkauf%21&order.1.orderNumber=3485464&order.1.depositAmount=1.00&order.1.timeModified=30.07.2015+11%3A41%3A37&order.1.contractNumber=mail%40shop.com&order.1.payments=1&order.1.timeCreated=30.07.2015+11%3A41%3A37&order.1.amount=1.00&order.1.credits=0&order.1.approveAmount=0&order.1.merchantNumber=1&objectsTotal=1&status=0&orders=1",
              headers: {}
            )
        end

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

        before do
          stub_request(:post, "https://checkout.wirecard.com/seamless/backend/getorderdetails").
            with(body: default_backend_request_hash.merge(
              {
                "orderNumber"=>"123456789",
                "requestFingerprint"=>"05590300ee16cd890e900bb45923b9f950d4d1743ec9b335f20da86f8c9ec9838882f49736fef09a47560a8462d0833c05d0aa978c32fe9adcc4086f95c4751f"
              }
            )).
            to_return(
              status: 200,
              body: "status=0&objectsTotal=0&orders=0",
              headers: {}
            )
        end

        it { is_expected.to eq ({ objects_total: "0", orders: "0", status: "0" }) }
      end
    end

    context 'when order_number is missing' do
      let(:options) { Hash.new }

      before do
        stub_request(:post, "https://checkout.wirecard.com/seamless/backend/getorderdetails").
          with(body: default_backend_request_hash.merge(
            {
              "requestFingerprint"=>"dfd315b6687aa1f213450008cb3932b29c23601097a0f1a120377938149c3be84e54dafd36e7cf75385e6f356cff79f1a084712d099bedeb2735e63df861b2c5"
            }
          )).
          to_return(
            status: 200,
            body: "error.1.consumer_message=Order+number+is+missing.&error.1.error_code=11011&error.1.message=Order+number+is+missing.&errors=1&status=1",
            headers: {}
          )
      end

      it { is_expected.to eq ({:"error.1.consumer_message" => "Order number is missing.",
                               :"error.1.error_code" => "11011",
                               :"error.1.message" => "Order number is missing.",
                               errors: "1",
                               status: "1"}) }
    end
  end
end
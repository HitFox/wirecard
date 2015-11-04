RSpec.shared_context 'configuration' do
  let(:config) { {
    host: 'checkout.wirecard.com',
    endpoint: 'https://checkout.wirecard.com/seamless',
    customer_id: 'D200001',
    shop_id: 'qmore',
    password: 'jcv45z',
    secret: 'B8AKTPWBRMNBV455FG6M2DANE99WU2',
    success_url: 'http://localhost.success.url',
    failure_url: 'http://localhost.failure.url',
    cancel_url: 'http://localhost.cancel.url',
    service_url: 'http://localhost.service.url',
    confirm_url: 'http://localhost.confirm.url',
    return_url: 'http://localhost.return.url',
    language: 'en'
   } }

  before do
    Wirecard.configure do |configuration|
      configuration.host = config[:host]
      configuration.endpoint = config[:endpoint]
      configuration.customer_id = config[:customer_id]
      configuration.shop_id = config[:shop_id]
      configuration.currency = nil
      configuration.password = config[:password]
      configuration.secret = config[:secret]
      configuration.success_url = config[:success_url]
      configuration.failure_url = config[:failure_url]
      configuration.cancel_url = config[:cancel_url]
      configuration.service_url = config[:service_url]
      configuration.confirm_url = config[:confirm_url]
      configuration.return_url = config[:return_url]
      configuration.language = config[:language]
    end
  end

  let(:default_request_hash) do
    {
      "customerId" => config[:customer_id],
      "shopId" => config[:shop_id]
    }
  end
end

RSpec.shared_context 'stub requests' do

  before do

    ##### Wirecard::Backend::GetOrderDetails #####
    stub_request(:post, "https://checkout.wirecard.com/seamless/backend/getorderdetails").
      with(body: {"customerId"=>"D200001", "language"=>"en", "orderNumber"=>"23473341", "password"=>"jcv45z", "requestFingerprint"=>"4b5b4733bf2ec86456f180a75ed08eb7c0d3abbe8b3f834f313a5f35b8fe85fdf9568765f08cf8921be864764585d85a12357b9826e0f197255d69afc4155a45", "shopId"=>"qmore"},
           headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'228', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
      to_return(status: 200, body: "payment.1.1.currency=EUR&payment.1.1.state=payment_approved&payment.1.1.orderNumber=23473341&payment.1.1.timeModified=30.07.2015+10%3A52%3A53&payment.1.1.merchantNumber=1&payment.1.1.timeCreated=30.07.2015+10%3A52%3A53&payment.1.1.depositAmount=0.00&payment.1.1.paymentType=VPG&payment.1.1.approvalCode=123456&payment.1.1.paymentNumber=23473341&payment.1.1.approveAmount=1.00&payment.1.1.operationsAllowed=DEPOSIT%2CAPPROVEREVERSAL&order.1.orderNumber=23473341&order.1.paymentType=VPG&order.1.brand=VISA&order.1.depositAmount=0&order.1.state=ORDERED&order.1.timeModified=30.07.2015+10%3A52%3A53&order.1.currency=EUR&order.1.contractNumber=0815DemoContract&order.1.orderDescription=Lisa+Kaufrausch%2C+K-Nr%3A+54435&order.1.payments=1&order.1.timeCreated=30.07.2015+10%3A52%3A53&order.1.orderReference=OR-23473341&order.1.refundAmount=0&order.1.acquirer=card+complete&order.1.customerStatement=Danke+f%C3%BCr+den+Einkauf%21&order.1.amount=1.00&order.1.credits=0&order.1.approveAmount=1.00&order.1.merchantNumber=1&objectsTotal=1&status=0&orders=1", headers: {})

    stub_request(:post, "https://checkout.wirecard.com/seamless/backend/getorderdetails").
      with(body: {"customerId"=>"D200001", "language"=>"en", "orderNumber"=>"56453412", "password"=>"jcv45z", "requestFingerprint"=>"512954a4d75c781d02c36504fe51f170470af50e1438bd61e757ed21d262072d1e292a3df96c5c4a5fcce7fdb24b25be211346692175ec6ebe09f574f2e7d478", "shopId"=>"qmore"},
           headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'228', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
      to_return(:status => 200, :body => "payment.1.1.currency=EUR&payment.1.1.state=payment_approved&payment.1.1.orderNumber=56453412&payment.1.1.timeModified=30.07.2015+11%3A20%3A53&payment.1.1.merchantNumber=1&payment.1.1.timeCreated=30.07.2015+11%3A20%3A53&payment.1.1.depositAmount=0.00&payment.1.1.paymentType=APG&payment.1.1.approvalCode=123456&payment.1.1.paymentNumber=56453412&payment.1.1.approveAmount=1.00&payment.1.1.operationsAllowed=DEPOSIT%2CAPPROVEREVERSAL&order.1.orderNumber=56453412&order.1.paymentType=APG&order.1.brand=MasterCard&order.1.depositAmount=0&order.1.state=ORDERED&order.1.timeModified=30.07.2015+11%3A20%3A53&order.1.currency=EUR&order.1.contractNumber=0815DemoContract&order.1.orderDescription=Max+Mustermann%2C+K-Nr%3A+12345&order.1.payments=1&order.1.timeCreated=30.07.2015+11%3A20%3A53&order.1.orderReference=OR-56453412&order.1.refundAmount=0&order.1.acquirer=PayLife&order.1.customerStatement=Danke+f%C3%BCr+den+Einkauf%21&order.1.amount=1.00&order.1.credits=0&order.1.approveAmount=1.00&order.1.merchantNumber=1&objectsTotal=1&status=0&orders=1", :headers => {})

    stub_request(:post, "https://checkout.wirecard.com/seamless/backend/getorderdetails").
      with(body: {"customerId"=>"D200001", "language"=>"en", "orderNumber"=>"543132154", "password"=>"jcv45z", "requestFingerprint"=>"865d590cfa0b89587893ce64fb510977b1c49e81d47c6591c887a7470cc85828022034f262dbfcc8aadad6a2e269e4f85eb836427ece3699cf4d898364502dbb", "shopId"=>"qmore"},
          headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'229', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
      to_return(status: 200, body: "payment.1.1.currency=EUR&payment.1.1.state=payment_deposited&payment.1.1.senderAccountOwner=Test+Consumer&payment.1.1.timeModified=30.07.2015+11%3A32%3A49&payment.1.1.merchantNumber=1&payment.1.1.timeCreated=30.07.2015+11%3A32%3A49&payment.1.1.senderIBAN=DE0000000000000000&payment.1.1.depositAmount=1.00&payment.1.1.senderBIC=PNAGDE00000&payment.1.1.senderBankName=Test+Bank&payment.1.1.senderBankNumber=1234578&payment.1.1.approvalCode=00000-00000-AAAAAAAA-BBBB&payment.1.1.senderCountry=DE&payment.1.1.orderNumber=543132154&payment.1.1.paymentType=SUE&payment.1.1.securityCriteria=1&payment.1.1.paymentNumber=543132154&payment.1.1.approveAmount=1.00&payment.1.1.senderAccountNumber=1234567890&payment.1.1.batchNumber=131&order.1.brand=sofortueberweisung&order.1.paymentType=SUE&order.1.state=ORDERED&order.1.currency=EUR&order.1.orderDescription=F.+Realtime%2C+K-Nr%3A+12111&order.1.orderReference=OR-543132154&order.1.refundAmount=0&order.1.customerStatement=Danke+f%C3%BCr+den+Einkauf%21&order.1.orderNumber=543132154&order.1.depositAmount=1.00&order.1.timeModified=30.07.2015+11%3A32%3A49&order.1.contractNumber=1234%2F1234&order.1.payments=1&order.1.timeCreated=30.07.2015+11%3A32%3A49&order.1.amount=1.00&order.1.credits=0&order.1.approveAmount=0&order.1.merchantNumber=1&objectsTotal=1&status=0&orders=1", headers: {})

    stub_request(:post, "https://checkout.wirecard.com/seamless/backend/getorderdetails").
      with(body: {"customerId"=>"D200001", "language"=>"en", "orderNumber"=>"3485464", "password"=>"jcv45z", "requestFingerprint"=>"c057221a6a402100f70f2ab519b71f047fe15d0e3b20d3777c0a6620682efde52c0902c321dca0185bd72f461acfc5634ecd6ab14c1791e316883a31d8560f42", "shopId"=>"qmore"},
           headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'227', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
      to_return(status: 200, body: "payment.1.1.currency=EUR&payment.1.1.state=payment_deposited&payment.1.1.timeModified=30.07.2015+11%3A41%3A37&payment.1.1.paypalPayerAddressStatus=unverified&payment.1.1.merchantNumber=1&payment.1.1.timeCreated=30.07.2015+11%3A41%3A37&payment.1.1.paypalPayerAddressState=Musterland&payment.1.1.depositAmount=1.00&payment.1.1.approvalCode=4PW61566G53703003&payment.1.1.paypalPayerAddressCountry=AT&payment.1.1.paypalPayerFirstName=Test&payment.1.1.orderNumber=3485464&payment.1.1.paypalPayerEmail=buyer%40paypal.com&payment.1.1.paypalPayerLastName=Consumer&payment.1.1.paymentType=PPL&payment.1.1.paypalPayerAddressCity=Musterstadt&payment.1.1.paypalPayerAddressZIP=1234&payment.1.1.paypalProtectionEligibility=ExtendedCustomerProtection&payment.1.1.paymentNumber=3485464&payment.1.1.approveAmount=1.00&payment.1.1.paypalPayerID=PAYER123456ID&payment.1.1.batchNumber=129&order.1.brand=PayPal&order.1.paymentType=PPL&order.1.state=ORDERED&order.1.currency=EUR&order.1.orderDescription=E.+Bay%2C+K-Nr%3A+55266&order.1.orderReference=OR-3485464&order.1.refundAmount=0&order.1.customerStatement=Danke+f%C3%BCr+den+Einkauf%21&order.1.orderNumber=3485464&order.1.depositAmount=1.00&order.1.timeModified=30.07.2015+11%3A41%3A37&order.1.contractNumber=mail%40shop.com&order.1.payments=1&order.1.timeCreated=30.07.2015+11%3A41%3A37&order.1.amount=1.00&order.1.credits=0&order.1.approveAmount=0&order.1.merchantNumber=1&objectsTotal=1&status=0&orders=1", headers: {})

    stub_request(:post, "https://checkout.wirecard.com/seamless/backend/getorderdetails").
      with(body: {"customerId"=>"D200001", "language"=>"en", "orderNumber"=>"123456789", "password"=>"jcv45z", "requestFingerprint"=>"05590300ee16cd890e900bb45923b9f950d4d1743ec9b335f20da86f8c9ec9838882f49736fef09a47560a8462d0833c05d0aa978c32fe9adcc4086f95c4751f", "shopId"=>"qmore"},
           headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'229', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
      to_return(status: 200, body: "status=0&objectsTotal=0&orders=0", headers: {})

      stub_request(:post, "https://checkout.wirecard.com/seamless/backend/getorderdetails").
        with(body: {"customerId"=>"D200001", "language"=>"en", "password"=>"jcv45z", "requestFingerprint"=>"dfd315b6687aa1f213450008cb3932b29c23601097a0f1a120377938149c3be84e54dafd36e7cf75385e6f356cff79f1a084712d099bedeb2735e63df861b2c5", "shopId"=>"qmore"},
             headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'207', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
        to_return(status: 200, body: "error.1.consumer_message=Order+number+is+missing.&error.1.error_code=11011&error.1.message=Order+number+is+missing.&errors=1&status=1", headers: {})

     ##### Wirecard::Backend::Deposit #####
     stub_request(:post, "https://checkout.wirecard.com/seamless/backend/deposit").
       with(body: {"amount"=>"1000", "currency"=>"EUR", "customerId"=>"D200001", "language"=>"en", "orderNumber"=>"23473341", "password"=>"jcv45z", "requestFingerprint"=>"db96723ef9e69e323a63d65f634c03badaa7e373f8ca65f1e764162464e28414e476072aca98b7ae2aee7dd045b52abd102b3f74b3a6d72223ca51f105368792", "shopId"=>"qmore"},
            headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'253', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
       to_return(status: 200, body: "paymentNumber=23473341&status=0", headers: {})

      stub_request(:post, "https://checkout.wirecard.com/seamless/backend/deposit").
        with(body: {"currency"=>"EUR", "customerId"=>"D200001", "language"=>"en", "orderNumber"=>"23473341", "password"=>"jcv45z", "requestFingerprint"=>"8f998a36a3060d88970dd90b648aafec16ecc11db82c60f84dd636e1bb0a976b11a93b5f204d84e426356c6c0bdad8514c954e56ad351fcbcb12c5484cc6002f", "shopId"=>"qmore"},
             headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'241', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
        to_return(status: 200, body: "error.1.errorCode=11017&error.1.message=Amount+is+missing.&error.1.consumerMessage=Amount+is+missing.&errors=1&status=1", headers: {})

      stub_request(:post, "https://checkout.wirecard.com/seamless/backend/deposit").
        with(body: {"amount"=>"1000", "customerId"=>"D200001", "language"=>"en", "orderNumber"=>"23473341", "password"=>"jcv45z", "requestFingerprint"=>"fbd960f2ed92db219ee1c85790bda0b7c591e0d7b004d8cf1a4a554f112b33a02ee13203e62d53395f80dbc10c6b98f070dbb5b03084387deacc3689f8143753", "shopId"=>"qmore"},
             headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'240', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
        to_return(status: 200, body: "error.1.errorCode=11019&error.1.message=Currency+is+missing.&error.1.consumerMessage=Currency+is+missing.&errors=1&status=1", headers: {})

      stub_request(:post, "https://checkout.wirecard.com/seamless/backend/deposit").
        with(body: {"amount"=>"1000", "currency"=>"EUR", "customerId"=>"D200001", "language"=>"en", "password"=>"jcv45z", "requestFingerprint"=>"85482e191e98ba78be9699348a51a0b848efafe60d7afc3cb091ad33cf0fb487838096540bbf3c7201b4c9bd0a1a897a5d9e3b440243cc2ee5a22114d585ddf5", "shopId"=>"qmore"},
             headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'232', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
        to_return(status: 200, body: "error.1.errorCode=11011&error.1.message=Order+number+is+missing.&error.1.consumerMessage=Order+number+is+missing.&errors=1&status=1", headers: {})

      ##### Wirecard::Backend::DepositReversal #####
      stub_request(:post, "https://checkout.wirecard.com/seamless/backend/depositreversal").
        with(body: {"customerId"=>"D200001", "language"=>"en", "orderNumber"=>"23473341", "password"=>"jcv45z", "paymentNumber"=>"23473341", "requestFingerprint"=>"51b6ba02b404a79a3ae20b60d8f37c8756be90940e6b7ee5f1399eb541ad26839b06a880959a6837cad9c694b8f44974a8855e5cbdc04cd95337352f2cd53f12", "shopId"=>"qmore"},
             headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'251', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
        to_return(status: 200, body: "status=0", headers: {})

      stub_request(:post, "https://checkout.wirecard.com/seamless/backend/depositreversal").
        with(body: {"customerId"=>"D200001", "language"=>"en", "orderNumber"=>"23473341", "password"=>"jcv45z", "requestFingerprint"=>"4b5b4733bf2ec86456f180a75ed08eb7c0d3abbe8b3f834f313a5f35b8fe85fdf9568765f08cf8921be864764585d85a12357b9826e0f197255d69afc4155a45", "shopId"=>"qmore"},
             headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'228', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
        to_return(status: 200, body: "error.1.errorCode=11012&error.1.message=Payment+number+is+missing.&error.1.consumerMessage=Payment+number+is+missing.&errors=1&status=1", headers: {})

      stub_request(:post, "https://checkout.wirecard.com/seamless/backend/depositreversal").
        with(body: {"customerId"=>"D200001", "language"=>"en", "password"=>"jcv45z", "paymentNumber"=>"23473341", "requestFingerprint"=>"4b5b4733bf2ec86456f180a75ed08eb7c0d3abbe8b3f834f313a5f35b8fe85fdf9568765f08cf8921be864764585d85a12357b9826e0f197255d69afc4155a45", "shopId"=>"qmore"},
             headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'230', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
        to_return(status: 200, body: "error.1.errorCode=11011&error.1.message=Order+number+is+missing.&error.1.consumerMessage=Order+number+is+missing.&errors=1&status=1", headers: {})

      stub_request(:post, "https://checkout.wirecard.com/seamless/backend/depositreversal").
        with(body: {"customerId"=>"D200001", "language"=>"en", "password"=>"jcv45z", "requestFingerprint"=>"dfd315b6687aa1f213450008cb3932b29c23601097a0f1a120377938149c3be84e54dafd36e7cf75385e6f356cff79f1a084712d099bedeb2735e63df861b2c5", "shopId"=>"qmore"},
             headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'207', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
        to_return(status: 200, body: "error.1.errorCode=11011&error.1.message=Order+number+is+missing.&error.1.consumerMessage=Order+number+is+missing.&error.2.errorCode=11012&error.2.message=Payment+number+is+missing.&error.2.consumerMessage=Payment+number+is+missing.&errors=2&status=1", headers: {})

      ##### Wirecard::Backend::GenerateOrderNumber #####
      stub_request(:post, "https://checkout.wirecard.com/seamless/backend/generateordernumber").
        with(body: {"customerId"=>"D200001", "language"=>"en", "password"=>"jcv45z", "requestFingerprint"=>"dfd315b6687aa1f213450008cb3932b29c23601097a0f1a120377938149c3be84e54dafd36e7cf75385e6f356cff79f1a084712d099bedeb2735e63df861b2c5", "shopId"=>"qmore"},
             headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'207', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
        to_return(status: 200, body: "status=0&orderNumber=1113051", headers: {})

      ##### Wirecard::Backend::ApproveReversal #####
      stub_request(:post, "https://checkout.wirecard.com/seamless/backend/approvereversal").
        with(body: {"customerId"=>"D200001", "language"=>"en", "orderNumber"=>"23473341", "password"=>"jcv45z", "requestFingerprint"=>"4b5b4733bf2ec86456f180a75ed08eb7c0d3abbe8b3f834f313a5f35b8fe85fdf9568765f08cf8921be864764585d85a12357b9826e0f197255d69afc4155a45", "shopId"=>"qmore"},
             headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'228', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
        to_return(status: 200, body: "status=0", headers: {})

      stub_request(:post, "https://checkout.wirecard.com/seamless/backend/approvereversal").
        with(body: {"customerId"=>"D200001", "language"=>"en", "password"=>"jcv45z", "requestFingerprint"=>"dfd315b6687aa1f213450008cb3932b29c23601097a0f1a120377938149c3be84e54dafd36e7cf75385e6f356cff79f1a084712d099bedeb2735e63df861b2c5", "shopId"=>"qmore"},
             headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'207', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
        to_return(status: 200, body: "error.1.errorCode=11011&error.1.message=Order+number+is+missing.&error.1.consumerMessage=Order+number+is+missing.&errors=1&status=1", headers: {})

      ##### Wirecard::Backend::RecurPayment #####
      stub_request(:post, "https://checkout.wirecard.com/seamless/backend/recurpayment").
        with(body: {"amount"=>"1000", "autoDeposit"=>"Yes", "currency"=>"EUR", "customerId"=>"D200001", "customerStatement"=>"some statement", "language"=>"en", "orderDescription"=>"some description", "orderNumber"=>"23473341", "orderReference"=>"MercantID_X345456", "password"=>"jcv45z", "requestFingerprint"=>"aceb23e9015a4b84fbafd0e0498d526c7e92ca4e7a96fe4ca7c042852271d46e8c54dd217eb1ddaf3a343f9f170fb52629e4a91b8fabd9f13e6c4b2df0077b6f", "shopId"=>"qmore", "sourceOrderNumber"=>"23473341"},
             headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'396', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
        to_return(status: 200, body: "status=0&orderNumber=23473341", headers: {})

      stub_request(:post, "https://checkout.wirecard.com/seamless/backend/recurpayment").
        with(body: {"autoDeposit"=>"Yes", "customerId"=>"D200001", "customerStatement"=>"some statement", "language"=>"en", "orderNumber"=>"23473341", "orderReference"=>"MercantID_X345456", "password"=>"jcv45z", "requestFingerprint"=>"a2170fe58a24491b64e57fe08c18f9711faa819051cdae13cabb85c46a93d6fc844abb9fa85857d02d806caf6a54e4b74ab89487b35564deafce432a30de9609", "shopId"=>"qmore"},
             headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'310', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
        to_return(status: 200, body: "error.1.errorCode=11159&error.1.message=Source+ORDERNUMBER+is+missing.&error.1.consumerMessage=Source+ORDERNUMBER+is+missing.&error.2.errorCode=11020&error.2.message=Order+description+is+missing.&error.2.consumerMessage=Order+description+is+missing.&error.3.errorCode=11017&error.3.message=Amount+is+missing.&error.3.consumerMessage=Amount+is+missing.&error.4.errorCode=11019&error.4.message=Currency+is+missing.&error.4.consumerMessage=Currency+is+missing.&errors=4&status=1", headers: {})

      stub_request(:post, "https://checkout.wirecard.com/seamless/backend/recurpayment").
        with(body: {"amount"=>"1000", "currency"=>"EUR", "customerId"=>"D200001", "language"=>"en", "orderDescription"=>"some description", "password"=>"jcv45z", "requestFingerprint"=>"aa3ea63cc812e30d1b2a412e8e24dbc26d3379dbe1b7c5ca672cc67d42aa45e0dc8454e5de07635aa3514449ff3bb7792d40ecc086a0a7c252119380cc738f40", "shopId"=>"qmore", "sourceOrderNumber"=>"23473341"},
             headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'293', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
        to_return(status: 200, body: "status=0&orderNumber=23473341", headers: {})

      ##### Wirecard::Backend::Refund #####
      stub_request(:post, "https://checkout.wirecard.com/seamless/backend/refund").
        with(body: {"amount"=>"1000", "currency"=>"EUR", "customerId"=>"D200001", "language"=>"en", "orderNumber"=>"23473341", "password"=>"jcv45z", "requestFingerprint"=>"db96723ef9e69e323a63d65f634c03badaa7e373f8ca65f1e764162464e28414e476072aca98b7ae2aee7dd045b52abd102b3f74b3a6d72223ca51f105368792", "shopId"=>"qmore"},
             headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'253', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
        to_return(status: 200, body: "creditNumber=14949449&status=0", headers: {})

      stub_request(:post, "https://checkout.wirecard.com/seamless/backend/refund").
        with(body: {"customerId"=>"D200001", "language"=>"en", "password"=>"jcv45z", "requestFingerprint"=>"dfd315b6687aa1f213450008cb3932b29c23601097a0f1a120377938149c3be84e54dafd36e7cf75385e6f356cff79f1a084712d099bedeb2735e63df861b2c5", "shopId"=>"qmore"},
             headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'207', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
        to_return(status: 200, body: "error.1.errorCode=11011&error.1.message=Order+number+is+missing.&error.1.consumerMessage=Order+number+is+missing.&error.2.errorCode=11019&error.2.message=Currency+is+missing.&error.2.consumerMessage=Currency+is+missing.&error.3.errorCode=11017&error.3.message=Amount+is+missing.&error.3.consumerMessage=Amount+is+missing.&errors=3&status=1", headers: {})


      stub_request(:post, "https://checkout.wirecard.com/seamless/backend/refundreversal").
        with(body: {"creditNumber"=>"14949449", "customerId"=>"D200001", "language"=>"en", "orderNumber"=>"23473341", "password"=>"jcv45z", "requestFingerprint"=>"4f92a11fb765e115e9c7e2e89ff1b08692fb61f7cce1aac88ab5afec4dc61d9d76ff1e72ccd18b836232177df29c03f5e4416c61c7954275e5a8fe9026545e5c", "shopId"=>"qmore"},
             headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'250', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
        to_return(status: 200, body: "status=0", headers: {})

      stub_request(:post, "https://checkout.wirecard.com/seamless/backend/refundreversal").
        with(body: {"customerId"=>"D200001", "language"=>"en", "password"=>"jcv45z", "requestFingerprint"=>"dfd315b6687aa1f213450008cb3932b29c23601097a0f1a120377938149c3be84e54dafd36e7cf75385e6f356cff79f1a084712d099bedeb2735e63df861b2c5", "shopId"=>"qmore"},
             headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'207', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
        to_return(status: 200, body: "error.1.errorCode=11011&error.1.message=Order+number+is+missing.&error.1.consumerMessage=Order+number+is+missing.&error.2.errorCode=11013&error.2.message=Credit+number+is+missing.&error.2.consumerMessage=Credit+number+is+missing.&errors=2&status=1", headers: {})

      ##### Wirecard::Backend::TransferFund::ExistingOrder #####
      stub_request(:post, "https://checkout.wirecard.com/seamless/backend/transferfund").
        with(body: {"amount"=>"1000", "creditNumber"=>"14949449", "currency"=>"EUR", "customerId"=>"D200001", "customerStatement"=>"invoice text", "fundTransferType"=>"EXISTINGORDER", "language"=>"en", "orderDescription"=>"some description", "orderNumber"=>"56453412", "orderReference"=>"MercantID F34545", "password"=>"jcv45z", "requestFingerprint"=>"9514833a4bc44c6c13c320a04ae55d4ae1dabf6c99645f01658dd6f6370f49f8806de59e7dbdb1f8b75994e57e011c347d7908650164955b43f28a7a8d11127b", "shopId"=>"qmore", "sourceOrderNumber"=>"23473341"},
             headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'430', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
        to_return(status: 200, body: "status=0&creditNumber=14949449", headers: {})

      stub_request(:post, "https://checkout.wirecard.com/seamless/backend/transferfund").
        with(body: {"amount"=>"1000", "currency"=>"EUR", "customerId"=>"D200001", "fundTransferType"=>"EXISTINGORDER", "language"=>"en", "orderDescription"=>"some description", "password"=>"jcv45z", "requestFingerprint"=>"403782c9e852642fd0dbdbf21ca741c92f1c7df7ab18aece4cec68171d5d9cc59647a56aa539714228413e582973a9c7e31f79036d02bcf77ae2af289d4d662d", "shopId"=>"qmore", "sourceOrderNumber"=>"23473341"},
             headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'324', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
        to_return(status: 200, body: "status=0&creditNumber=14949449", headers: {})

      stub_request(:post, "https://checkout.wirecard.com/seamless/backend/transferfund").
        with(body: {"creditNumber"=>"14949449", "customerId"=>"D200001", "customerStatement"=>"invoice text", "language"=>"en", "orderNumber"=>"56453412", "orderReference"=>"MercantID F34545", "password"=>"jcv45z", "requestFingerprint"=>"8e12d164fd45310ba0772e9c81c0362fb133ee9a137a2071acba359f1608c687e046604e8f58988c84c6d1bed1949c3ef437cad13599287b5801529445838b83", "shopId"=>"qmore"},
             headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'313', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
        to_return(status: 200, body: "error.1.errorCode=11017&error.1.message=Amount+is+missing.&error.1.consumerMessage=Amount+is+missing.&error.2.errorCode=11019&error.2.message=Currency+is+missing.&error.2.consumerMessage=Currency+is+missing.&error.3.errorCode=11020&error.3.message=Order+description+is+missing.&error.3.consumerMessage=Order+description+is+missing.&error.4.errorCode=11216&error.4.message=FUNDTRANSFERTYPE+is+missing.&error.4.consumerMessage=FUNDTRANSFERTYPE+is+missing.&errors=4&status=1", headers: {})
  end
end
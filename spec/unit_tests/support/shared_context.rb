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

  let(:default_backend_request_hash) do
    default_request_hash.merge(
    {
      "language"=>"en",
      "password"=>"jcv45z"
    }
    )
  end
end

RSpec.shared_context 'stub requests' do

  before do

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
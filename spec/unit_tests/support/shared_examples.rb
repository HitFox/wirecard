RSpec.shared_examples 'configuration' do
  let(:config) { {
    host: 'checkout.wirecard.com',
    endpoint: 'https://checkout.wirecard.com/seamless',
    customer_id: 'D200001',
    shop_id: 'qmore',
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
end

RSpec.shared_examples 'stub requests' do
  before do
    
    ##### Wirecard::DataStorage::Init #####
    stub_request(:post, "https://checkout.wirecard.com/seamless/dataStorage/init").
      with(body: {"customerId"=>"D200001", "javascriptScriptVersion"=>"pci3", "language"=>"en", "orderIdent"=>"order123", "requestFingerprint"=>"855b5ac85144d35c4b32d35ddfbdbbd34770cb33b4d5271a1566c3892e43eb2507253e17e840fd6f2ddcc49d49c79580ba96e239bfe5d4df90bf02ea0484e1b2", "returnUrl"=>"http://localhost.return.url", "shopId"=>"qmore"},
                  headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'284', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
      to_return(status: 200, body: "storageId=b2737b746627482e0b024097cadb1b41&javascriptUrl=https%3A%2F%2Fcheckout.wirecard.com%2Fseamless%2FdataStorage%2Fjs%2FD200001%2Fqmore%2Fb2737b746627482e0b024097cadb1b41%2FdataStorage.js", headers: {})
    
    stub_request(:post, "https://checkout.wirecard.com/seamless/dataStorage/init").
      with(body: {"customerId"=>"D200001", "javascriptScriptVersion"=>"pci3", "language"=>"en", "requestFingerprint"=>"6ebcaa502c04de25dbdca74e6eaa44a7cb3cd0adb2b171433099726848ea40cee3adac2f9c89b6102e02bd2a19106a1012fe0fe72f68b75cc7432adf973cdc18", "returnUrl"=>"http://localhost.return.url", "shopId"=>"qmore"},
                  headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'264', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
      to_return(status: 200, body: "error.1.errorCode=15300&error.1.message=ORDERIDENT+has+an+invalid+length.&error.1.consumerMessage=ORDERIDENT+has+an+invalid+length.&errors=1", headers: {})
      
      
    ##### Wirecard::DataStorage::Read #####
    stub_request(:post, "https://checkout.wirecard.com/seamless/dataStorage/read").
      with(body: {"customerId"=>"D200001", "requestFingerprint"=>"eb6a688db153b6f215c12d98c9cccaf8d60dec0e64bab967e2cae0b868fa30a3edf91ef8a17ee40d3984b0a4742aecf049446fea696740470e45121ccdfe6cbd", "shopId"=>"qmore", "storageId"=>"b2737b746627482e0b024097cadb1b41"},
                  headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'222', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
      to_return(status: 200, body: "storageId=b2737b746627482e0b024097cadb1b41&paymentInformations=0", headers: {})
    
    stub_request(:post, "https://checkout.wirecard.com/seamless/dataStorage/read").
      with(body: {"customerId"=>"D200001", "requestFingerprint"=>"7378bce0cab7ef7edb08f178c23146332ecce459409393b4d97e4e0e2da0bf86489f0d1c28a3cb8d549b56879e8b42a42a61a59c184d4f2335a1531b97b5bc27", "shopId"=>"qmore"},
                  headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'179', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
      to_return(status: 200, body: "error.1.errorCode=11302&error.1.message=STORAGEID+is+missing.&errors=1", :headers => {})
      
    
    ##### Wirecard::PaymentProcess::Init #####
    stub_request(:post, "https://checkout.wirecard.com/seamless/frontend/init").
      with(body: {"amount"=>"1000", "cancelUrl"=>"http://localhost.cancel.url", "confirmUrl"=>"http://localhost.confirm.url", "consumerIpAddress"=>"127.0.0.1", "consumerUserAgent"=>"some agent", "currency"=>"USD", "customerId"=>"D200001", "failureUrl"=>"http://localhost.failure.url", "language"=>"en", "orderDescription"=>"some description", "paymentType"=>"CCARD", "requestFingerprint"=>"a4428885692839169559ea3ed3e232a0e1dc64b8d2415b47317ff6bffc296557bc9c8a9a08151c1b520c9d37a5a797e8e7fcad206e1b9573d7d863a040f1f1bb", "requestFingerprintOrder"=>"customerId,shopId,language,currency,successUrl,failureUrl,cancelUrl,serviceUrl,confirmUrl,storageId,paymentType,amount,consumerIpAddress,consumerUserAgent,orderDescription,requestFingerprintOrder,secret", "serviceUrl"=>"http://localhost.service.url", "shopId"=>"qmore", "storageId"=>"b2737b746627482e0b024097cadb1b41", "successUrl"=>"http://localhost.success.url"},
                  headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'855', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
      to_return(status: 200, body: "redirectUrl=https%3A%2F%2Fcheckout.wirecard.com%2Fseamless%2Ffrontend%2FD200001qmore_DESKTOP%2Fselect.php%3FSID%3Dttkbc64otkqk067oca49ft0cr5", headers: {})
      
    stub_request(:post, "https://checkout.wirecard.com/seamless/frontend/init").
      with(body: {"cancelUrl"=>"http://localhost.cancel.url", "confirmUrl"=>"http://localhost.confirm.url", "currency"=>true, "customerId"=>"D200001", "failureUrl"=>"http://localhost.failure.url", "language"=>"en", "requestFingerprint"=>"136635ebc59fe9b6d5ca009fa022adb7cf09f16a611e11670e7a399026b3957c9f59269c3eeeb27fdb3bc45c2f19f920e0a3d5f896cbbe81e9cc0f9b39a52d61", "requestFingerprintOrder"=>"customerId,shopId,language,successUrl,failureUrl,cancelUrl,serviceUrl,confirmUrl,requestFingerprintOrder,secret", "serviceUrl"=>"http://localhost.service.url", "shopId"=>"qmore", "successUrl"=>"http://localhost.success.url"},
                  headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Connection'=>'close', 'Content-Length'=>'582', 'Content-Type'=>'application/x-www-form-urlencoded', 'Host'=>'checkout.wirecard.com', 'User-Agent'=>'### User Agent ###'}).
      to_return(status: 200, body: "error.1.message=PAYMENTTYPE+is+missing.&error.1.consumerMessage=PAYMENTTYPE+is+missing.&error.1.errorCode=11051&error.2.message=Currency+is+missing.&error.2.consumerMessage=Currency+is+missing.&error.2.errorCode=11019&error.3.message=Order+description+is+missing.&error.3.consumerMessage=Order+description+is+missing.&error.3.errorCode=11020&error.4.message=Amount+is+missing.&error.4.consumerMessage=Amount+is+missing.&error.4.errorCode=11017&error.5.message=IP-Address+is+missing.&error.5.consumerMessage=IP-Address+is+missing.&error.5.errorCode=11146&error.6.message=USER_AGENT+is+missing.&error.6.consumerMessage=USER_AGENT+is+missing.&error.6.errorCode=11130&errors=6", headers: {})
  end
end

RSpec.shared_examples 'Wirecard::Base#defaults' do
  it { expect(subject[:customer_id]).to eq(config[:customer_id]) }
  it { expect(subject[:shop_id]).to eq(config[:shop_id]) }
end
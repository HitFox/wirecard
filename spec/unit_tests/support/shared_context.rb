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
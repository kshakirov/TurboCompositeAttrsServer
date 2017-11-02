class PriceAttrReader

  def initialize
    @pricer_rest_service = 'timms.turbointernational.com:8080/magmi/prices'
  end

  def get_rest_prices skus
    JSON.parse(RestClient.post @pricer_rest_service,
                               skus.to_json,
                               :content_type => :json, :accept => :json)
  end
end
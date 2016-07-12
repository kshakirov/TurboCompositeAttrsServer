class PriceAttrReader
  def get_attribute ids
    response = JSON.parse(RestClient.post '52.9.105.129:8080/magmi/prices',ids.to_json, :content_type => :json, :accept => :json)
    unless response.nil?
      return response
    end
    nil
  end
end
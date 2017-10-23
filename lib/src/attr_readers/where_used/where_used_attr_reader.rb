class WhereUsedAttrReader
  include TurboUtils

  def initialize  graph_service_url
    @graph_service_url = graph_service_url
    @not_external = prepare_manufacturers
  end

  def is_external_manufacturer? manufacturer_name
    @not_external.index manufacturer_name
  end

  def query_service id
    url = "#{@graph_service_url}/parts/#{id}/ancestors"
    response = RestClient.get  url
    JSON.parse response.body
  end

  def get_attribute id
      query_service id
  end



  def aggregate_turbo_part_numbers response, item_new
    if response.has_key? item_new[:sku]
      response[item_new[:sku]][:turboPartNumbers].push item_new[:turboPartNumbers]
    else
      response[item_new[:sku]] = item_new
      response[item_new[:sku]][:turboPartNumbers] = [item_new[:turboPartNumbers]]

    end
  end
end
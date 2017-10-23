class BomReader
  def initialize graph_service_url
    @graph_service_url = graph_service_url
  end

  def query_service id, distance=2
    url = "#{@graph_service_url}/parts/#{id}/boms?distance=#{distance}"
    response = RestClient.get  url
    JSON.parse response.body
  end

  def get_attribute id
    query_service id
  end
end
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
    tries ||= 10
    url = "#{@graph_service_url}/parts/#{id}/ancestors"
    begin
      response = RestClient.get url
      JSON.parse response.body
    rescue Exception => e
      if (tries -= 1) > 0
        puts "Getting an error #{e.message}"
        puts "Sleeping 1 sec ... "
        sleep 1
        retry
      else
        puts "Giving up .."
      end
    end
  end

  def get_attribute id
      query_service id
  end
end
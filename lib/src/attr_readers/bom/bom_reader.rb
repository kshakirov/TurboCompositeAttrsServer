class BomReader
  def initialize graph_service_url
    @graph_service_url = graph_service_url
    @range = Random.new
  end


  def query_service sku, distance=10
    tries ||= 10
    url = "#{@graph_service_url}/parts/#{sku}/boms?distance=#{distance}"
    begin
      response =  RestClient::Request.execute(:method => :get, :url => url, :timeout => 60, :open_timeout => 60,
                                              :headers => {'Connection' => 'close'})
      JSON.parse response.body
    rescue StandardError => e
      if (tries -= 1) > 0
        time_to_sleep = @range.rand(3.5)
        puts " Sku [#{sku}], Attempt [#{tries.to_s}], Sleeping #{time_to_sleep} sec ... "
        sleep time_to_sleep
        retry
      else
        puts "Giving up, Sku [#{sku}] "
      end
    end
  end


  def get_attribute sku
    query_service sku
  end
end
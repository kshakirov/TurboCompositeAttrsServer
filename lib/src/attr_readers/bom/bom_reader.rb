class BomReader
  def initialize graph_service_url
    @graph_service_url = graph_service_url
    @range = Random.new
  end


  def query_service id, distance=2
    tries ||= 10
    url = "#{@graph_service_url}/parts/#{id}/boms?distance=#{distance}"
    begin
      response =  RestClient::Request.execute(:method => :get, :url => url, :timeout => 60, :open_timeout => 60)
      JSON.parse response.body
    rescue Exception => e
      if (tries -= 1) > 0
        time_to_sleep = @range.rand(3.5)
        puts " Sku [#{id}], Attempt [#{tries.to_s}], Sleeping #{time_to_sleep} sec ... "
        sleep time_to_sleep
        retry
      else
        puts "Giving up, Sku [#{id}] "
      end
    end
  end


  def get_attribute id
    query_service id
  end
end
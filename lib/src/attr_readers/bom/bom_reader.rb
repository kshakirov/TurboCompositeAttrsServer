class BomReader
  def initialize graph_service_url
    @graph_service_url = graph_service_url
  end


  def query_service id, distance=2
    tries ||= 10
    url = "#{@graph_service_url}/parts/#{id}/boms?distance=#{distance}"
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
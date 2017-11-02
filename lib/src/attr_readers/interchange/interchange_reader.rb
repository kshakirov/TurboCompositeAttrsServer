class InterchangeReader
  include TurboUtils

  def initialize graph_service_url
    #@not_external = prepare_manufacturers
    @graph_service_url = graph_service_url
    @range = Random.new
  end

  def is_external_manufacturer? manufacturer_name
    @not_external.index manufacturer_name
  end

  def query_service id
    tries ||= 10
    begin
      url = "#{@graph_service_url}/parts/#{id}/interchanges"
      response =  RestClient::Request.execute(:method => :get, :url => url, :timeout => 60, :open_timeout => 60,
                                              :headers => {'Connection' => 'close'})
      JSON.parse response.body
    rescue StandardError => e
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
    response = query_service id
    response['parts'] unless response.nil?
  end
end
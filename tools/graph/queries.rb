ENV['RACK_ENV'] = 'development'
require_relative '../mappers_helper'
require 'arangorb'

class TurboGraphQuery
  def initialize
    config = YAML::load(IO.read(__dir__ + '/config.yaml'))
    user = config[ENV['RACK_ENV']]['arango_user']
    pass = config[ENV['RACK_ENV']]['password']
    server = config[ENV['RACK_ENV']]['arango_host']
    port = config[ENV['RACK_ENV']]['port']
    ArangoServer.default_server user: user,
                                password: pass,
                                server: server,
                                port: port
  end

  private
  def query_string_filtered direction, starting_vertex, max_depth, type
    %{
          FOR v, e, p IN 1..#{max_depth} #{direction} 'parts/#{starting_vertex}' GRAPH 'BomGraph'
           FILTER p.edges[0].type == '#{type}'
          Return p.vertices[1]
}
  end

  def query_string direction, starting_vertex, max_depth
    %{
          FOR v, e, p IN 1..#{max_depth} #{direction} 'parts/#{starting_vertex}' GRAPH 'BomGraph'
          Return p.vertices[1]
}
  end

  def prepare_query query_string
    ArangoAQL.new query: query_string, database: "Bom"
  end

  public
  def find_bom id
    query = prepare_query(query_string_filtered("OUTBOUND", id, 1, "direct"))
    query.execute
  end

  def find_where_used id
    query = prepare_query(query_string("INBOUND", id, 5))
    query.execute
  end

end

while true do
  puts "Enter Part Id"
  id = gets
  id = id.chomp
  puts "Now BOM #{id}"
  graph_query = TurboGraphQuery.new
  query = graph_query.find_bom id
  query.result.each {|r| puts r.key}


  puts "Now Where used #{id}"

  query = graph_query.find_where_used id
  query.result.each {|r| puts r.key}
end

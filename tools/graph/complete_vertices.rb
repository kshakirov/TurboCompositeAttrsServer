ENV['RACK_ENV'] = 'development'
require_relative '../mappers_helper'
require 'arangorb'


class TestVertice
  def initialize database_name, graph_name, edges_collection='bom_edges', vortex_collection="parts"
    ArangoServer.default_server user: "root", password: "servantes", server: "localhost", port: "8529"
    @database_name = database_name
    @graph_name = graph_name
    @edges_collection = edges_collection
    @bom_databse = ArangoDatabase.new database: database_name
    @parts = @bom_databse.collection vortex_collection
  end


  def get_original_part id
    Part.find id
  end

  def sync_doc synced_doc, part
    data = {
        "part_number" => part.manfr_part_num,
        "part_type" => part.part_type.name,
        "description" => part.description,
        "name" => part.name
    }
    synced_doc.update body: data
  end

  def synchronize
    @parts.allDocuments(limit: 45000, batchSize: 45000).each do |doc|
      part = get_original_part doc.key
      synced_doc = @parts.document doc.key
      puts "TO SYNC [#{doc.key}]"
      sync_doc synced_doc, part
    end
  end
end

vertice =  TestVertice.new "Bom", "BomGraph"

vertice.synchronize
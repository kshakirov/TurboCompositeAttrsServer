ENV['RACK_ENV'] = 'development'
require_relative '../mappers_helper'
require 'arangorb'


class TestInterchange
  def initialize database_name, graph_name, edges_collection='interchange_edges', vortex_collection="parts", header_vx_collection='interchange_headers'
    ArangoServer.default_server user: "root", password: "servantes", server: "localhost", port: "8529"
    @database_name = database_name
    @graph_name = graph_name
    @edges_collection = edges_collection
    @bom_databse = ArangoDatabase.new database: database_name
    @parts = @bom_databse.collection vortex_collection
    @headers = @bom_databse.collection header_vx_collection
  end

  private
  def header_vertex_avail? header_id
    vertex = @headers.document header_id
    vertex = vertex.retrieve
    if vertex.class.name == 'ArangoDocument'
      vertex
    else
      false
    end
  end

  def create_header_vertex header_id
    v_key =  header_id.to_s
    v_body = {
        header: header_id
    }
    ArangoDocument.new database: @bom_databse,
                       collection: @headers, key: v_key, body: v_body
  end

  def find_header_vertex header_id
    vertex = header_vertex_avail? header_id
    unless vertex
      vertex = create_header_vertex header_id
      vertex.create
    end
    vertex
  end

  def add_interchange_vertex header_id
    find_header_vertex header_id
  end

  def add_header_vertex header_id
    find_header_vertex header_id
  end

  def create_edge header_vertex, interchange_vertex
    e_key = header_vertex .key   + "_" + interchange_vertex.key.to_i.to_s
    e_body = {
        type: "interchange"
    }

    edge = ArangoDocument.new key: e_key,
                              body: e_body,
                              from: header_vertex,
                              to: interchange_vertex,
                              database: @bom_databse,
                              collection: @edges_collection
    edge.create

  end

  def add_2_graph header_vertex, interchange_vertex
    create_edge header_vertex, interchange_vertex
  end

  def build_interchange_sub_graph header_vertex, interchanges
    interchanges.each do |i|
      interchange_vertex = @parts.document i.part_id.to_s
      add_2_graph header_vertex, interchange_vertex
    end
  end

  public

  def synchronize
    InterchangeHeader.all.each do |header|
      header_id = "header_#{header.id}"
      puts "Header [#{header_id}]"
      header_vertex = find_header_vertex header_id
      build_interchange_sub_graph header_vertex, header.interchange_item
    end
  end
end


test_interchange = TestInterchange.new "Bom", "BomGraph"

test_interchange.synchronize


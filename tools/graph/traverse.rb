require_relative '../mappers_helper'
require 'arangorb'


class TestTraversal

  def initialize database_name, graph_name, edges_collection='bom_edges', vortex_collection="parts"
    ArangoServer.default_server user: "root", password: "servantes", server: "localhost", port: "8529"
    @database_name = database_name
    @graph_name = graph_name
    @edges_collection = edges_collection
    @bom_databse = ArangoDatabase.new database: "Bom"
    @parts = @bom_databse.collection vortex_collection
  end



  def _traverse starting_vertex
    traversal = ArangoTraversal.new database: @database_name, graph: @graph_name
    traversal.vertex = starting_vertex
    traversal.graph = @graph_name # define used Graph
    traversal.edgeCollection = @edges_collection
    traversal
  end

  def traverse_bom key_name, depth
    starting_vertex = find_vertex_by_key key_name
    bom_traversal = _traverse starting_vertex
    bom_traversal.out
    bom_traversal.maxDepth = depth
    bom_traversal.execute
  end

  def traverse_where_used key_name, depth
    wu_traversal = _traverse key_name
    wu_traversal.in
    wu_traversal.maxDepth =depth
    wu_traversal.execute
  end

  def find_vertex_by_key key_name
    doc = @parts.document key_name
    doc.retrieve
  end


end

class TestGraph

  def initialize
    ArangoServer.default_server user: "root", password: "servantes", server: "localhost", port: "8529"
    @bom_graph = ArangoGraph.new database: "Bom", graph: "BomGraph"
    @bom_databse = ArangoDatabase.new database: "Bom"
    @parts = @bom_databse.collection "parts"
  end


  def doc_avail? v_key
    doc = @parts.document v_key.to_s
    doc = doc.retrieve
    if doc.class.name == 'ArangoDocument'
      doc
    else
      false
    end
  end

  def create_graph_vertex part_id
    v_key = part_id.to_s
    v_body = {
        part_number: part_id
    }
    ArangoDocument.new database: @bom_databse,
                       collection: @parts, key: v_key, body: v_body
  end

  def find_vertex part_id
    doc = doc_avail? part_id
    unless doc
      doc = create_graph_vertex part_id
      doc.create
    end
    doc
  end

  def add_child_vertex part_id
    find_vertex part_id
  end

  def add_parent_vertex part_id
    find_vertex part_id
  end

  def create_edge vertex_parent, vertex_child
    e_key = vertex_parent.key.to_i.to_s  + "_"  + vertex_child.key.to_i.to_s
    e_body = {
        type: "direct"
    }

    edge = ArangoDocument.new key: e_key,
                              body: e_body,
                                from: vertex_parent,
                                to: vertex_child,
                                database: "Bom",
                                collection: "bom_edges"
    edge.creates

  end

  def add_2_graph vbom_desc_recored
    vertex_child = add_child_vertex vbom_desc_recored.part_id_descendant
    vertex_parent = add_parent_vertex vbom_desc_recored.part_id_ancestor
    create_edge vertex_parent, vertex_child
  end


  def map_specific_parts where_str

    VbomDescendant.where(where_str).
        find_in_batches(batch_size: 10) do |group|
      group.each do |vbom_desc_recored|
        p vbom_desc_recored
        add_2_graph vbom_desc_recored
      end
    end
  end
end

ENV['RACK_ENV'] = 'development'
require_relative 'traverse'
test_graph = TestGraph.new
test_graph.map_specific_parts "distance=1"
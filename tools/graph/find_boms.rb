require_relative 'traverse'






test_traversal = TestTraversal.new "Bom", "BomGraph", "bom_edges"





result =  test_traversal.traverse_bom "35001", 4
paths = result.paths
paths.map do |node|
   unless node['edges'].empty?
     p node['vertices'][1].key
   end
end

p paths.size





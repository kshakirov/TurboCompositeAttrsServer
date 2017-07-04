ENV['RACK_ENV'] = 'development'
require_relative 'traverse'

class CheckCorrect
  def initialize
    @test_traversal = TestTraversal.new "Bom", "BomGraph", "bom_edges"
  end

  def collect_descendants paths
    paths.map do |node|
      unless node['edges'].empty?
        node['vertices'][1].key
      end
    end
  end

  def resolve_descendants descs
    parts = Part.find descs.uniq
    puts "Size Is #{parts.size}"
    parts.map {|part| part.manfr_part_num}
  end

  def run id
    result = @test_traversal.traverse_bom id, 4
    descs = collect_descendants(result.paths)
    resolve_descendants(descs).map{|desc| puts desc}
  end
end


check = CheckCorrect.new
while true do
  puts "Enter Parent Id "
  id = gets
  check.run id.chomp
end











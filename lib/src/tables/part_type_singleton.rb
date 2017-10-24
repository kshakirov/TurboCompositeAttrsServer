class PartTypeSingleton
  include Singleton
  def initialize
    @part_types = PartType.all.map{|pt| [pt.id, pt.name]}
    @part_types = @part_types.to_h
  end

  def get_part_type_name id
    @part_types[id]
  end

end
class MajorComponent
  def initialize
    parent_type_id = 9
    @major_components = PartType.where(parent_part_type_id: parent_type_id).map{|p| p.name}
  end
  def is_major_component? bom
    @major_components.find{|mc| mc.downcase == bom[:part_type].downcase}
  end

  def is_cartridge bom
    bom[:part_type] == "Cartridge"
  end

  def build_major_comps_list boms
    components =  boms.select{|bom|is_major_component?(bom) }
    cartridge = boms.select{|bom| is_cartridge(bom)}
    cartridge + components
  end


end
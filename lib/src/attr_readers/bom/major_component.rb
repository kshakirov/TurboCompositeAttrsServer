class MajorComponent
  def is_major_component? bom
    bom[:part_type_parent] == 'major_component'
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
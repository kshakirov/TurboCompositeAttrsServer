class MajorComponent
  def is_major_component? bom
    bom[:part_type_parent] == 'major_component'
  end

  def is_cartridge bom
    bom[:part_type] == "Cartridge"
  end


  def make_cartridge_first mcs, bom
      if mcs.size > 0
        mcs.unshift(bom)
      else
        mcs.push(bom)
      end
  end

  def build boms
    mcs = []
    boms.each do |bom|
      if  is_major_component?(bom)
        mcs.push bom
      elsif is_cartridge(bom)
        make_cartridge_first(mcs, bom)
      end
    end
    mcs
  end


end
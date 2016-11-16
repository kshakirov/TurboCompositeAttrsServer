class BomBuilder

  def initialize
    @interchanges_getter = InterchangeGetter.new
  end

  def is_ti_manufacturer part
    part.manfr.name == "Turbo International"
  end

  def make_list_item
    {
        sku: nil,
        description: nil,
        quantity: nil,
        part_type: nil,
        part_number: nil,
        name: nil,
        type: nil,
        part_type_parent: nil,
        interchanges: []
    }
  end

  def build_boms_list_item_ti bom, part
    item = make_list_item
    item[:sku] =part.id
    item[:description] = part.description
    item[:quantity] =bom['quantity']
    item[:part_type] =part.part_type.name
    item[:part_number] = part.manfr_part_num
    item[:name] = part.name || part.part_type.name + '-' + part.manfr_part_num
    item[:type] = bom[:type]
    item[:part_type_parent] = bom[:part_type_parent]
    item
  end

  def is_type_direct? bom
    bom['type'] == 'direct'
  end

  def find_ti_interchange tinterchanges
    tinterchanges.each do |i|
      part = Part.find i[:id]
      if is_ti_manufacturer(part)
        return part
      end
    end
  end

  def get_ti_part sku
    interchanges = @interchanges_getter.get_cached_interchange(sku)
    unless not interchanges or  interchanges.empty?
      return find_ti_interchange(interchanges)
    end
    nil
  end


  def build_boms_list_item_oem bom, part
    item = make_list_item
    ti_part = get_ti_part(part.id)
    if ti_part.nil?
      item[:part_type] =part.part_type.name
      item[:quantity] =bom['quantity']
      item[:type] = bom[:type]
      item[:part_type_parent] = bom[:part_type_parent]
      item[:interchanges] = [{:part_number => part.manfr_part_num, :sku => part.id}]
    else
      item = build_boms_list_item_ti(bom, ti_part)
      item[:interchanges] = [{:part_number => part.manfr_part_num, :sku => part.id}]
    end
    item
  end

  def build_boms_list boms
    boms_list = boms.select { |b| is_type_direct?(b) }
    boms_list.map do |bl|
      part = Part.find bl['descendant_sku']
      if is_ti_manufacturer(part)
        build_boms_list_item_ti(bl, part)
      else
        build_boms_list_item_oem(bl, part)
      end
    end
  end

end
class BomBuilder
  include TurboUtils

  def is_external_manufacturer? manufacturer_name
    @not_external.index manufacturer_name
  end

  def initialize
    @interchanges_getter = InterchangeGetter.new
    @not_external = prepare_manufacturers
  end

  def is_ti_manufacturer part
    part.manfr.name == "Turbo International"
  end

  def is_int_ti_manufacturer interchange
    interchange[:manufacturer] == "Turbo International"
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
    item[:part_type_parent] = bom['part_type_parent']
    item[:interchanges] = find_all_interchanges(part.id)
    item
  end

  def is_type_direct? bom
    bom['type'] == 'direct'
  end

  def find_ti_interchange interchanges
    interchanges.each do |i|
      if is_int_ti_manufacturer(i)
        return i
      end
    end
    nil
  end

  def find_all_interchanges sku
    interchanges = @interchanges_getter.get_cached_interchange(sku)
    if interchanges
      return interchanges.map { |i| {part_number: i[:part_number], sku: i[:id]} }
    end
    []
  end

  def find_all_non_ti_interchanges sku
    interchanges = @interchanges_getter.get_cached_interchange(sku)
    if interchanges
      ins = interchanges.select { |i| not is_int_ti_manufacturer(i) }
      return ins.map { |i| {part_number: i[:part_number], sku: i[:id]} }
    end
    []
  end

  def get_ti_part sku
    interchanges = @interchanges_getter.get_cached_interchange(sku)
    unless not interchanges or interchanges.empty?
      return find_ti_interchange(interchanges)
    end
    nil
  end


  def build_boms_list_item_oem bom, part
    item = make_list_item
    ti_part = get_ti_part(part.id)
    if ti_part.nil?
      item[:oe_sku] = part.id
      item[:oe_part_number] = part.manfr_part_num
      item[:part_type] =part.part_type.name
      item[:quantity] =bom['quantity']
      item[:type] = bom[:type]
      item[:part_type_parent] = bom['part_type_parent']
      item[:interchanges] = find_all_non_ti_interchanges(part.id)
    else
      item[:oe_sku] = part.id
      item[:oe_part_number] = part.manfr_part_num
      item[:sku] =ti_part[:id]
      item[:description] = ""
      item[:quantity] =bom['quantity']
      item[:part_type] =part.part_type.name
      item[:part_type_parent] = bom['part_type_parent']
      item[:part_number] = ti_part[:part_number]
      item[:name] = part.part_type.name + '-' + ti_part[:part_number]
      item[:interchanges] = find_all_non_ti_interchanges(part.id)
    end
    item
  end

  def build_boms_list boms
    boms_list = boms.select { |b| is_type_direct?(b) }
    boms_list.map do |bl|
      part = Part.find bl['descendant_sku']
      unless is_external_manufacturer?(part.manfr.name)
        if is_ti_manufacturer(part)
          build_boms_list_item_ti(bl, part)
        else
          build_boms_list_item_oem(bl, part)
        end
      end
    end
  end

end
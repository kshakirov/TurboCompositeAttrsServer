class BomBuilder
  include TurboUtils

  def is_external_manufacturer? part
    manufacturer_name = @manufacturer.get_manufacturer_name part.id
    @not_external.index manufacturer_name
  end

  def initialize redis_cache
    @interchanges_getter = InterchangeGetter.new redis_cache
    @not_external = prepare_manufacturers
    @manufacturer = ManufacturerSingleton.instance
    @part_type = PartTypeSingleton.instance
  end

  def is_ti_manufacturer part
    manufacturer_name = @manufacturer.get_manufacturer_name part.manfr_id
    manufacturer_name == "Turbo International"
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
        interchanges: [],
        distance: nil,
        parentId: nil
    }
  end


  def build_ti_dto bom, part
    item = make_list_item
    item[:sku] =part.id
    item[:description] = part.description
    item[:quantity] =bom['qty']
    item[:part_type] = @part_type.get_part_type_name(part.part_type_id)
    item[:part_number] = part.manfr_part_num
    item[:name] = part.name || @part_type.get_part_type_name(part.part_type_id) + '-' + part.manfr_part_num
    item[:type] = bom[:type]
    item[:interchanges] = find_all_interchanges(part.id)
    item[:distance] = bom['relationDistance']
    item[:parentId] = bom['bomPartId']
    item
  end

  def is_type_direct? bom
    bom['nodeType'] == 'direct'
  end

  def find_ti_interchange interchanges
    interchanges.find { |i| is_int_ti_manufacturer(i) }
  end

  def find_all_interchanges sku
    interchanges = @interchanges_getter.get_cached_interchange(sku) || []
    interchanges.map { |i| {part_number: i[:part_number], sku: i[:id]} }
  end

  def find_all_non_ti_interchanges sku
    o_is = @interchanges_getter.get_cached_interchange(sku) || []
    is = o_is.select { |i| not is_int_ti_manufacturer(i) }
    is = is.map { |i| {part_number: i[:part_number], sku: i[:id]} }
    tis = o_is.find_all { |i| is_int_ti_manufacturer(i) }
    if tis and tis.size > 1
        is + tis[1..(tis.size  - 1)]
    else
      is
    end
  end

  def get_ti_part sku
    interchanges = @interchanges_getter.get_cached_interchange(sku) || []
    find_ti_interchange(interchanges)
  end


  def build_oem_dto bom, part
    item = make_list_item
    ti_part = get_ti_part(part.id)
    if ti_part.nil?
      item[:oe_sku] = part.id
      item[:oe_part_number] = part.manfr_part_num
      item[:part_type] =@part_type.get_part_type_name(part.part_type_id)
      item[:type] = bom[:type]
      item[:interchanges] = find_all_non_ti_interchanges(part.id)
    else
      item[:oe_sku] = part.id
      item[:oe_part_number] = part.manfr_part_num
      item[:sku] =ti_part[:id]
      item[:description] = ""
      item[:part_type] =@part_type.get_part_type_name(part.part_type_id)
      item[:part_number] = ti_part[:part_number]
      item[:name] = @part_type.get_part_type_name(part.part_type_id) + '-' + ti_part[:part_number]
      item[:interchanges] = find_all_non_ti_interchanges(part.id)
    end
    item[:quantity] =bom['qty']
    item[:distance] = bom['relationDistance']
    item[:parentId] = bom['bomPartId']
    item
  end


  def get_bom_part boms
    ids = boms.map { |bp| bp['partId'] }
    Part.where id:  ids
  end

  def pair_bom_and_parts boms, parts
    boms.map do |bom|
      part  = parts.find { |p| bom['partId'] == p.id.to_s }
      [bom, part]
    end
  end

  def filter_out_ext_manufacturer boms_parts
    boms_parts.select { |bp| not is_external_manufacturer? bp[1] }
  end

  def _build boms_parts
    boms_parts.map do |bp|
      if is_ti_manufacturer(bp[1])
        build_ti_dto(bp.first, bp.second)
      else
        build_oem_dto(bp.first, bp.second)
      end
    end
  end

  def _build_bom_dto boms
    parts = get_bom_part boms
    parts ||= []
    boms_parts = pair_bom_and_parts boms, parts
    boms_parts = filter_out_ext_manufacturer boms_parts
    _build boms_parts
  end


  def build_bom_dto boms
    _build_bom_dto boms
  end

end
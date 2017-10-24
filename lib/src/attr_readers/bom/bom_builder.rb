class BomBuilder
  include TurboUtils

  def is_external_manufacturer? part
    manufacturer_name = @manufacturer.get_manufacturer_name part.id
    @not_external.index manufacturer_name
  end

  def initialize
    @interchanges_getter = InterchangeGetter.new
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
        interchanges: []
    }
  end


  def build_ti_dto bom, part
    item = make_list_item
    item[:sku] =part.id
    item[:description] = part.description
    item[:quantity] =bom['qty']
    item[:part_type] = @part_type.get_part_type_name(part.part_type_id)
    item[:part_number] = part.manfr_part_num
    item[:name] = part.name || @part_type.get_part_type_name(part.part_type_id)  + '-' + part.manfr_part_num
    item[:type] = bom[:type]
    item[:part_type_parent] = bom['part_type_parent']
    item[:interchanges] = find_all_interchanges(part.id)
    item
  end

  def is_type_direct? bom
    bom['nodeType'] == 'direct'
  end

  def find_ti_interchange interchanges
    interchanges.find{|i| is_int_ti_manufacturer(i)}
  end

  def find_all_interchanges sku
    interchanges = @interchanges_getter.get_cached_interchange(sku) || []
    interchanges.map { |i| {part_number: i[:part_number], sku: i[:id]} }
  end

  def find_all_non_ti_interchanges sku
    interchanges = @interchanges_getter.get_cached_interchange(sku) || []
    interchanges = interchanges.select { |i| not is_int_ti_manufacturer(i) }
    interchanges.map { |i| {part_number: i[:part_number], sku: i[:id]} }
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
      item[:quantity] =bom['qty']
      item[:type] = bom[:type]
      item[:part_type_parent] = bom['part_type_parent']
      item[:interchanges] = find_all_non_ti_interchanges(part.id)
    else
      item[:oe_sku] = part.id
      item[:oe_part_number] = part.manfr_part_num
      item[:sku] =ti_part[:id]
      item[:description] = ""
      item[:quantity] =bom['qty']
      item[:part_type] =@part_type.get_part_type_name(part.part_type_id)
      item[:part_type_parent] = bom['part_type_parent']
      item[:part_number] = ti_part[:part_number]
      item[:name] = @part_type.get_part_type_name(part.part_type_id)  + '-' + ti_part[:part_number]
      item[:interchanges] = find_all_non_ti_interchanges(part.id)
    end
    item
  end


  def get_bom_part boms
    ids = boms.map { |bp| bp['partId'] }
    Part.find ids
  end

  def pair_bom_and_parts boms, parts
    parts.map do |part|
      bom = boms.find { |bom| bom['partId'] == part.id.to_s }
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
    boms_parts = pair_bom_and_parts boms, parts
    boms_parts = filter_out_ext_manufacturer boms_parts
    _build boms_parts
  end


  def build_bom_dto boms
    _build_bom_dto boms
  end

end
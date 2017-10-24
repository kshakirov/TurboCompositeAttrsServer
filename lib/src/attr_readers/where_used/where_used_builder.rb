class WhereUsedBuilder

  def initialize
    @manufacturer = ManufacturerSingleton.instance
    @part_type = PartTypeSingleton.instance
    @interchanges_getter = InterchangeGetter.new
  end

  def is_ti_manufactured? value
    value[:manufacturer] == 'Turbo International'
  end

  def has_ti_part? value
    not value[:tiSku].nil?
  end

  def is_turbo? value
    value[:partType].downcase == 'turbo'
  end

  def is_cartridge? value
    value[:partType].downcase == 'cartridge'
  end

  def is_int_ti_manufacturer interchange
    interchange[:manufacturer] == "Turbo International"
  end

  def find_ti_interchange interchanges
    interchanges.find { |i| is_int_ti_manufacturer(i) }
  end

  def get_ti_part sku
    interchanges = @interchanges_getter.get_cached_interchange(sku) || []
    find_ti_interchange(interchanges)
  end

  def get_id_for_price value
    if is_ti_manufactured? value
      value[:sku]
    elsif has_ti_part? value
      value[:tiSku]
    else
      value[:sku]
    end
  end

  def get_rid_of_repetetive_turbos turbo_part_numbers
    unless turbo_part_numbers.nil?
      turbo_part_numbers.to_set
    end
  end

  def build_where_used_base item
    {
        :sku => item.id,
        :manufacturer => @manufacturer.get_manufacturer_name(item.manfr_id),
        :partNumber => item.manfr_part_num,
        :partType => @part_type.get_part_type_name(item.part_type_id),
        :description => item.description
    }
  end

  def add_turbo_type wu
    if is_turbo? wu
      turbo = Turbo.find wu[:sku]
      turbo.turbo_model.turbo_type.name
    end
  end

  def build_where_used_ti wu
    unless is_ti_manufactured? wu
      ti_part = get_ti_part(wu [:sku]) || Hash.new
      wu[:tiSku] = ti_part[:id]
      wu[:tiPartNumber] = ti_part[:part_number]
    end
    wu[:turboType] = add_turbo_type wu
    wu[:turboPartNumbers]
    wu
  end

  def build_where_used item
    wu = build_where_used_base item
    build_where_used_ti wu
  end

  def get_ids wus
    wus.map { |w| w['partId'] }
  end

  def _build wus
    ids = get_ids wus
    parts = Part.find ids
    parts.map { |p| build_where_used p }
  end

  def build wus
    unless wus.nil?
      _build wus
    end
  end
end

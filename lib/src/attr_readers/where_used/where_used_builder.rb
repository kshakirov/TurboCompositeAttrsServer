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

  def build_where_used_base item
    {
        :sku => item.id,
        :manufacturer => @manufacturer.get_manufacturer_name(item.manfr_id),
        :partNumber => item.manfr_part_num,
        :partType => @part_type.get_part_type_name(item.part_type_id),
        :description => item.description
    }
  end

  def bulk_get_turbo_model ids
    models = Turbo.eager_load(:turbo_model).find ids
    ids.map do |id|
      {
          sku: id,
          turbo_type_id: (models.find { |m| m.id == id }).turbo_model.turbo_type_id
      }
    end
  end

  def bulk_get_turbo_type models
    turbo_types_ids = models.map { |m| m[:turbo_type_id] }
    turbo_types = TurboType.find turbo_types_ids
    models.map do |m|
      {
          sku: m[:sku],
          turbo_type_name: (turbo_types.find { |tt| tt.id == m[:turbo_type_id] }).name
      }
    end
  end


  def add_turbo_type wus
    turbos = wus.select { |wu| is_turbo? wu }
    turbos_ids = turbos.map { |t| t[:sku] }
    models = bulk_get_turbo_model turbos_ids
    turbo_types_names = bulk_get_turbo_type models
    wus.map do |wu|
      t_name = turbo_types_names.find { |tt| tt[:sku] == wu[:sku] }
      unless t_name.nil?
        wu[:turboType] = t_name[:turbo_type_name]
      end
      wu
    end
  end

  def add_turbo_partnumbers wus, turbos
    wus.map do |wu|
      if is_cartridge? wu and not turbos.nil?
        wu[:turboPartNumbers] = turbos.to_a.join(", ")
      end
      wu
    end
  end

  def get_turbos wus
    turbos = wus.select { |wu| is_turbo?(wu) }
    turbos = turbos.map { |t| t[:partNumber] }
    turbos.to_set
  end

  def build_where_used_ti wu
    unless is_ti_manufactured? wu
      ti_part = get_ti_part(wu [:sku]) || Hash.new
      wu[:tiSku] = ti_part[:id]
      wu[:tiPartNumber] = ti_part[:part_number]
    end
    wu[:turboType] = nil
    wu[:turboPartNumbers] = nil
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
    wus = parts.map { |p| build_where_used p }
    turbos = get_turbos(wus)
    wus = add_turbo_partnumbers wus, turbos
    add_turbo_type wus
  end

  def build wus
    unless wus.nil?
      _build wus
    end
  end
end

class WhereUsedBuilder

  def initialize redis_cache
    @manufacturer = ManufacturerSingleton.instance
    @part_type = PartTypeSingleton.instance
    @interchanges_getter = InterchangeGetter.new redis_cache
    @where_used_getter = WhereUsedGetter.new redis_cache
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
    interchanges.find {|i| is_int_ti_manufacturer(i)}
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

  def bulk_get_turbo_with_model ids
    Turbo.eager_load(:turbo_model).find ids
  end

  def bulk_get_turbo_type_id turbo_model
    turbo_model.map do |tm|
      {
          sku: tm.part_id,
          turbo_type_id: tm.turbo_model.turbo_type_id,
      }
    end
  end

  def bulk_get_turbo_type_name turbo_type_ids
    turbo_types_ids = turbo_type_ids.map {|m| m[:turbo_type_id]}
    turbo_types = TurboType.find turbo_types_ids
    turbo_type_ids.map do |m|
      {
          sku: m[:sku],
          turbo_type_name: (turbo_types.find {|tt| tt.id == m[:turbo_type_id]}).name,
      }
    end
  end

  def get_model_name sku, turbo_model
    turbo = turbo_model.find {|tm| tm.part_id == sku}
    unless turbo.nil?
      turbo.turbo_model.name
    end
  end


  def add_turbo_type wus
    turbos = wus.select {|wu| is_turbo? wu}
    turbos_ids = turbos.map {|t| t[:sku]}
    turbo_model = bulk_get_turbo_with_model turbos_ids
    turbo_type_ids = bulk_get_turbo_type_id turbo_model
    turbo_types_names = bulk_get_turbo_type_name turbo_type_ids
    wus.map do |wu|
      t_name = turbo_types_names.find {|tt| tt[:sku] == wu[:sku]}
      unless t_name.nil?
        wu[:turboType] = t_name[:turbo_type_name]
        wu[:turboModel]= get_model_name(wu[:sku], turbo_model)
      end
      wu
    end
  end

  def add_turbo_partnumbers wus, turbos
    wus.map do |wu|
      if is_cartridge? wu and not turbos.nil?
        wu[:turboPartNumbers] = turbos.to_a
      else
        wu[:turboPartNumbers] = []
      end
      wu
    end
  end

  def get_turbos wus
    turbos = wus.select {|wu| is_turbo?(wu)}
    turbos = turbos.map {|t| t[:partNumber]}
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
    wus.map {|w| w['partId']}
  end

  def base_build wus
    ids = get_ids wus
    parts = Part.eager_load(:part_type).where(id: ids,inactive: false)
    parts ||= []
  end


  def component_build_cartridges cartridges
    wus = cartridges.map { |p| build_where_used p }
    wus_turbos = @where_used_getter.mget_cached_where_used cartridges.map { |c| c.id } unless wus.empty?
    wus.each_with_index.map do |w, index|
      w[:turboPartNumbers] = wus_turbos[index].values.map do |wt|
        if wt[:partNumber].nil?
          wt[:tiPartNumber]
        else
          wt[:partNumber]
        end
      end
      w
    end
  end

  def component_build_turbos turbos
    turbos = turbos.map { |p| build_where_used p }
    turbos.each_with_index.map do |w, index|
      w[:turboPartNumbers] = w[:partNumber].nil? ? w[:tiPartNumber] : w[:partNumber]
      w
    end

  end

  def component_build wus
    parts = base_build wus
    cartridges = parts.select { |p| p.part_type.name == "Cartridge" }
    turbos = parts.select { |p| p.part_type.name == "Turbo" }
    component_build_cartridges(cartridges) + component_build_turbos(turbos)

  end

  def turbo_cartridge_build wus
    parts =base_build wus
    wus = parts.map {|p| build_where_used p}
    turbos = get_turbos(wus)
    wus = add_turbo_partnumbers wus, turbos
    add_turbo_type wus
  end

  def build wus, part_type
    if part_type=="Turbo" or part_type=="Cartridge"
      turbo_cartridge_build wus
    else
      component_build wus
    end
  end
end

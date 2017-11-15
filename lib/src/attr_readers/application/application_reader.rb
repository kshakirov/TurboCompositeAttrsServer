class ApplicationReader
  def initialize redis_cache
    @where_used_getter = WhereUsedGetter.new redis_cache
  end

  private


  def check_nil_relation relation, method_name
    unless relation.nil?
      relation.send(method_name)
    end
  end

  def get_fuel_type car_engine
    unless car_engine.nil?
      check_nil_relation(car_engine.car_fuel_type, :name)
    end
  end

  def dto_apps_base applications
    applications.map do |app|
      {
          model: check_nil_relation(app.car_model, :name),
          model_id: app.car_model_id,
          make: nil,
          engine_size: check_nil_relation(app.car_engine, :engine_size),
          year: check_nil_relation(app.car_year, :name),
          fuel_type: get_fuel_type(app.car_engine)
      }
    end
  end

  def dto_apps_make applications, makes
    applications.map do |app|
      make = makes.find {|m| m.id == app[:model_id]}
      unless make.nil?
        app[:make] = check_nil_relation(make.car_make, :name)
      end
      app
    end
  end

  def get_make applications
    model_ids = applications.map {|app| app[:model_id]}
    model_ids = model_ids.to_set
    CarModel.eager_load(:car_make).where(id: model_ids.to_a)
  end

  def get_applications turbos
    turbos_ids = turbos.map {|t| t[:sku]}
    turbos_ids = turbos_ids.to_set
    car_model_eng_year_ids = TurboCarModelEngineYear.where(part_id: turbos_ids.to_a).map {|c| c.car_model_engine_year_id}
    applications = CarModelEngineYear.eager_load(:car_model, :car_year, :car_engine).where(id: car_model_eng_year_ids).all
    applications = dto_apps_base(applications)
    makes = get_make(applications)
    dto_apps_make applications, makes
  end

  def get_cartridges wus
    wus.select {|wu| wu[:partType] == 'Cartridge'}
  end

  def get_turbos wus
    wus.select {|wu| wu[:partType] == 'Turbo'}
  end

  def normalize_wu_cartridges wus
    wus_mdim_array = wus.map do |wu|
      wu.values
    end
    wus_mdim_array.flatten
  end

  def get_where_useds_for_cartridges cartridges
    cartridges_skus = cartridges.map {|c| c[:sku]}
    wus = @where_used_getter.mget_cached_where_used cartridges_skus
    wus ||= []
    normalize_wu_cartridges wus
  end

  public
  def get_attribute sku
    wus = @where_used_getter.get_cached_where_used sku
    wus ||={}
    turbos = get_turbos wus.values
    if turbos.empty?
      cartridges = get_cartridges wus.values
      cartridges_wus = get_where_useds_for_cartridges cartridges
      turbos = get_turbos cartridges_wus
    end
    get_applications(turbos)
  end
end
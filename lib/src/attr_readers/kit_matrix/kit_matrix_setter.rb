class KitMatrixSetter

  def initialize redis_cache
    @redis_cache = redis_cache
    @bom_getter = BomGetter.new @redis_cache
    @where_used_getter = WhereUsedGetter.new @redis_cache
    @service_kit_getter = ServiceKitGetter.new @redis_cache
  end

  def _base_header_array
    [
        {
            :field => 'part_number', :title => 'Name', :show => true
        },
        {
            :field => 'part_type', :title => 'Part', :show => true
        },
        {
            :field => 'description', :title => 'Desc', :show => true
        }
    ]
  end

  def _create_header name, sku, headers
    headers.push(
        {
            :field => name, :title => name, :show => true, :sku => sku
        }
    )
  end

  def create_row id, v, kit_matrix_rows
    if kit_matrix_rows.key? v[:part_number].to_s.to_sym
      kit_matrix_rows[v[:part_number].to_s.to_sym][id.to_s.to_sym] = v[:quantity]
    else
      kit_matrix_rows[v[:part_number].to_s.to_sym] = {
          :part_number => v[:part_number], :description => v[:description], :part_type => v[:part_type],
          id.to_s.to_sym => v[:quantity], :sku => v[:sku]}
    end
  end

  def _create_kit_matrix_table kits
    kit_matrix_rows = {}
    kit_matrix_headers = []
    kits.each do |key, value|
      id, sku = value[:part_number], value[:sku]
      if value[:manufacturer]=='Turbo International'
        _create_header id, sku, kit_matrix_headers
        value[:bom].each do |v|
          create_row(id, v, kit_matrix_rows)
        end
      end
    end
    return kit_matrix_rows, _base_header_array.concat(kit_matrix_headers)
  end

  def get_only_ti_boms sku
    @bom_getter.get_bom_attribute(sku, nil)
  end

  def add_part_data part
    {
        :manufacturer => part[:manufacturer],
        :part_number => part[:ti_part_number] || part[:part_number],
        :sku => part[:sku],
        :bom => get_only_ti_boms(part[:sku])
    }
  end

  def bulk_get_part service_kits
    Hash[service_kits.map do |sk|
      [sk[:sku].to_s.to_sym, add_part_data(sk)]
    end
    ]
  end


  def create_kit_matrix_table service_kits
    kit_matrix_hash = bulk_get_part service_kits
    _create_kit_matrix_table kit_matrix_hash
  end

  def get_parent_turbo_service_kits sku
    parents =@where_used_getter.get_cached_where_used(sku) || []
    unless parents.empty?
      paretn_turbo_sku =parents.keys.first
      @service_kit_getter.get_cached_sk paretn_turbo_sku
    end
  end

  def cache_kit_matrix sku, kit_matrixes
    @redis_cache.set_cached_response sku, 'kit_matrix', kit_matrixes
  end

  def set_kit_matrix_attribute sku
    service_kits = @service_kit_getter.get_cached_sk sku
    if not service_kits
      service_kits = get_parent_turbo_service_kits(sku)
      if service_kits
        kit_matrixes = create_kit_matrix_table service_kits
        cache_kit_matrix sku, kit_matrixes
      end
    else
      kit_matrixes = create_kit_matrix_table service_kits
      cache_kit_matrix sku, kit_matrixes
    end
  end
end
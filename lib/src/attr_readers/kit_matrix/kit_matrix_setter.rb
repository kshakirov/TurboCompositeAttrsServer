class KitMatrixSetter

  def initialize redis_cache=RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @kit_matrix = ServiceKitsAttrReader.new
    @redis_cache = redis_cache
    @bom_getter = BomGetter.new @redis_cache
  end

  def _base_header_array
    [{:field => 'part_number', :title => 'Name' , :show => true},
     {:field => 'part_type', :title => 'Part' , :show => true},
     {:field => 'description', :title => 'Desc' , :show => true}]
  end

  def _create_header name,sku, headers
    headers.push({:field => name, :title => name , :show => true, :sku => sku})
  end

  def create_row id, v, kit_matrix_rows
    if kit_matrix_rows.key? v[:part_number].to_s.to_sym
      kit_matrix_rows[v[:part_number].to_s.to_sym][id.to_s.to_sym] = v[:quantity]
    else
      kit_matrix_rows[v[:part_number].to_s.to_sym] = {
          :part_number => v[:part_number], :description => v[:description], :part_type => v[:part_type],
          id.to_s.to_sym => v[:quantity], :sku =>v[:sku]}
    end
  end

  def _create_kit_matrix_table kits
    kit_matrix_rows = {}
    kit_matrix_headers = []
    kits.each do |key, value|
      id,sku = value[:part_number], value[:sku]
      if value[:manufacturer]=='Turbo International'
        _create_header id, sku, kit_matrix_headers
        value[:bom].each do |v|
          create_row(id, v, kit_matrix_rows)
        end
      end
    end
    return kit_matrix_rows, _base_header_array.concat(kit_matrix_headers)
  end

  def _get_only_ti_boms sku
    boms = @bom_getter.get_bom_attribute(sku, nil)
    ti_boms = []
    boms.each do |bom|
      #if  bom[:ti_part_sku] and  bom[:ti_part_sku].size > 0 and bom[:ti_part_sku][0].nil?
        ti_boms.push bom
      #end
    end
    ti_boms
  end

  def _get_data sku
    part = Part.find sku
    {:manufacturer => part.manfr.name,
     :part_number => part.manfr_part_num,
     :sku => sku,
     :bom => _get_only_ti_boms(sku)
    }
  end

  def _get_it_rows ti_kits

  end

  def _get_ti_kits kits
    ti_kits = {}
    kits.each do |kit|
      if kit[:tiSku]
        ti_kits[kit[:tiSku]] = _get_data kit[:tiSku]
      else
        ti_kits[kit[:sku]] = _get_data kit[:sku]

      end
    end
    _create_kit_matrix_table ti_kits
  end


  def cache_kit_matrix sku
      km_headers =  @kit_matrix.get_attribute sku
      kms = _get_ti_kits km_headers
      @redis_cache.set_cached_response sku, 'kit_matrix', kms
  end

  def set_kit_matrix_attribute sku
    cache_kit_matrix sku
  end
end
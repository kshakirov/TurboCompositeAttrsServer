class KitMatrixSetter

  def initialize redis_cache=RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @kit_matrix = ServiceKitsAttrReader.new
    @redis_cache = redis_cache
    @bom_getter = BomGetter.new @redis_cache
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
        :manufacturer => part.manfr.name,
        :part_number => part.manfr_part_num,
        :sku => part.id,
        :bom => get_only_ti_boms(part.id)
    }
  end

  def bulk_get_part kit_matrix_array
    parts = Part.eager_load(:manfr).find kit_matrix_array
    Hash[parts.map { |p| [p.id.to_s.to_sym, add_part_data(p)] }]
  end

  def create_kit_matrix_array kit_matrix_headers
    kit_matrix_headers.map do |kit|
      if kit[:tiSku]
        kit[:tiSku]
      else
        kit[:sku]
      end
    end
  end


  def create_kit_matrix_table kit_matrix_headers
    kit_matrix_array = create_kit_matrix_array kit_matrix_headers
    kit_matrix_hash = bulk_get_part kit_matrix_array
    _create_kit_matrix_table kit_matrix_hash
  end


  def cache_kit_matrix sku, kit_matrixes
    @redis_cache.set_cached_response sku, 'kit_matrix', kit_matrixes
  end

  def set_kit_matrix_attribute sku
    kit_matrix_headers = @kit_matrix.get_attribute sku
    kit_matrixes = create_kit_matrix_table kit_matrix_headers
    cache_kit_matrix sku, kit_matrixes
  end
end
class CompositAttrsReader


  def _base_header_array
     [{:field => 'part_number', :title => 'Name' , :show => true},
                           {:field => 'part_type', :title => 'Part' , :show => true},
                           {:field => 'description', :title => 'Desc' , :show => true}]
  end

  def _create_header name, headers
    headers.push({:field => name, :title => name , :show => true})
  end


  def _create_kit_matrix_table kits

    kit_matrix_hash = {}
    kit_matrix_headers = []
    kits.each do |key, value|
      id = value[:part_number]
      if value[:manufacturer]=='Turbo International'
        _create_header id, kit_matrix_headers
        value[:bom].each do |v|
          if kit_matrix_hash.key? v[:part_number].to_s.to_sym
            kit_matrix_hash[v[:part_number].to_s.to_sym][id.to_s.to_sym] = v[:quantity]
          else
            kit_matrix_hash[v[:part_number].to_s.to_sym] = {
                :part_number => v[:part_number], :description => v[:description], :part_type => v[:part_type],
                id.to_s.to_sym => v[:quantity]}
          end
        end
      end
    end
  return kit_matrix_hash, _base_header_array.concat(kit_matrix_headers)
  end

  def _get_only_ti_boms sku
    boms = get_bom_attribute(sku, nil)
    ti_boms = []
    boms.each do |bom|
      if bom[:ti_part_sku].size > 0 and bom[:ti_part_sku][0].nil?
        ti_boms.push bom
      end
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

  def get_kit_matrix sku
    kits = @kit_matrix.get_attribute sku
    _get_ti_kits kits
  end
end
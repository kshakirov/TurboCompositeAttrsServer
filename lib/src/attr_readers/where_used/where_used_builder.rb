class WhereUsedBuilder

  def is_ti_manufactured? value
    value[:manufacturer] == 'Turbo International'
  end

  def has_ti_part? value
    not value[:tiSku].nil?
  end

  def load_item sku
    Part.find sku
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

  def build_where_used item
    {
        :sku => item.sku,
        :manufacturer => item.manfr.name,
        :partNumber => item.part_number,
        #:tiSku => item.ti_sku,
        #:tiPartNumber => item.ti_part_number,
        :partType => item.part_type.name,
        #:turboType => item.turbo_type,
        #:turboPartNumbers => item.turbo_part_number,
        :description => item.description
    }

  end


  def _build wus
    wus.map do |wu|
        part =  Part.find wu
        build_where_used part
    end
  end

  def build wus
    unless wus.nil?
      _build wus
    end
  end
end

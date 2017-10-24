class WhereUsedBuilder

  def initialize
    @manufacturer = ManufacturerSingleton.instance
    @part_type = PartTypeSingleton.instance
  end

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
        :sku => item.id,
        :manufacturer => @manufacturer.get_manufacturer_name(item.manfr_id),
        :partNumber => item.manfr_part_num,
        #:tiSku => item.ti_sku,
        #:tiPartNumber => item.ti_part_number,
        :partType => @part_type.get_part_type_name(item.part_type_id),
        #:turboType => item.turbo_type,
        #:turboPartNumbers => item.turbo_part_number,
        :description => item.description
    }

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

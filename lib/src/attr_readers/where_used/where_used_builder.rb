class WhereUsedBuilder

  def is_ti_manufactured?  value
     value[:manufacturer] == 'Turbo International'
  end

  def has_ti_part? value
    not value[:tiSku] .nil?
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

  def  get_rid_of_repetetive_turbos turbo_part_numbers
      unless turbo_part_numbers.nil?
        turbo_part_numbers.to_set
      end
  end


  def _build wus
    ids = []
    wus.each do |key, value|
      item = load_item value[:sku]
      wus[key][:description] = item.description
      wus[key][:turboPartNumbers] = get_rid_of_repetetive_turbos(value[:turboPartNumbers])
      ids.push(get_id_for_price(value))
    end
    ids
  end

  def build wus
    unless wus.nil?
      _build wus
    end
  end
end

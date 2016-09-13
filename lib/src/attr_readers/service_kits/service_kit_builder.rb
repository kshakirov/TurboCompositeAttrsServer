class ServiceKitBuilder

  def _get_ti_part_number sku
    unless sku.nil?
      part = Part.find sku
      part.manfr_part_num
    end
  end

  def _get_part value
     Part.find value[:sku]
  end

  def _has_ti_part? value
      not value[:tiSku].nil?
  end

  def _is_ti_part? part
    part.manfr.name== "Turbo International"
  end

  def _build service_kits
    ids = []
    service_kits.each_with_index do |value, index|
      part = _get_part value
      if _is_ti_part? part
        service_kits[index][:part_number] = nil
        service_kits[index][:ti_part_number] =     part.manfr_part_num
        service_kits[index][:tiSku] = value[:sku]
        ids.push value[:sku]
      else
        service_kits[index][:part_number] =  part.manfr_part_num
        service_kits[index][:ti_part_number] = _get_ti_part_number(value[:tiSku])
        ids.push value[:tiSku]
      end
     service_kits[index][:description] = part.description
    end
    ids
  end

  def build service_kits
    unless service_kits.nil?
     return  _build service_kits
    end
    []
  end
end
class ServiceKitBuilder
  include TurboUtils

  def initialize
    @not_external = prepare_manufacturers
  end

  def is_external_manufacturer? manufacturer_name
    @not_external.index manufacturer_name
  end

  def _get_ti_part_number sku
    unless sku.nil?
      part = Part.find sku
      part.manfr_part_num
    end
  end

  def _get_part sku
    Part.find sku
  end

  def _has_ti_part? value
    not value[:tiSku].nil?
  end

  def _is_ti_part? part
    part.manfr.name== "Turbo International"
  end

  def _build_list service_kits
    service_kits.map do |sk|
      part = _get_part sk[:sku]
      if not is_external_manufacturer?(part.manfr.name)
        if _is_ti_part? part
          sk[:part_number] = nil
          sk[:ti_part_number] = part.manfr_part_num
          sk[:tiSku] = sk[:sku]
        else
          sk[:part_number] = part.manfr_part_num
          sk[:ti_part_number] = _get_ti_part_number(sk[:tiSku])
        end
        sk
      else
        nil
      end
    end
  end

  def _get_skus service_kits_list
    service_kits_list.map do |sk|
      if sk[:tiSku]
        sk[:tiSku]
      else
        sk[:sku]
      end
    end
  end

  def _build service_kits
    service_kits_list = _build_list(service_kits)
    service_kits_list.compact!
    _get_skus(service_kits_list)
  end

  def build service_kits
    unless service_kits.nil?
      return _build service_kits
    end
    []
  end
end
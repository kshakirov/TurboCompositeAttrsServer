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

  def _has_ti_part? value
    not value[:tiSku].nil?
  end

  def _is_ti_part? part
    part.manfr.name== "Turbo International"
  end


  def bulk_get_part service_kits
    ids = service_kits.map{|sk| sk[:sku]}
    Part.eager_load(:manfr).find ids
  end

  def bulk_get_ti_parts  service_kits
      oem_sks=  service_kits.select{|sk| not sk[:part_number]}
      ti_ids = oem_sks.map{|osk|  osk[:tiSku]}
       Part.find ti_ids
  end

  def  add_ti_partnumber ti_parts, service_kits
    service_kits.map do |sk|
        unless sk[:part_number]
            ti_part = ti_parts.find{|tip| tip.id == sk[:tiSku]}
            sk[:ti_part_number] = ti_part.manfr_part_num
        end
    end
  end

  def combine_part_and_sk parts, service_kits
      service_kits.map do |sk|
          part = parts.find{|p| p.id==sk[:sku]}
          if _is_ti_part? part
            sk[:part_number] = nil
            sk[:ti_part_number] = part.manfr_part_num
            sk[:tiSku] = sk[:sku]
          else
            sk[:part_number] = part.manfr_part_num
            sk[:ti_part_number] =  sk[:tiPartNumber]
          end
          sk
      end
  end

  def filter_out_ext_manufacturer service_kits
      service_kits.select{|sk| not is_external_manufacturer?(sk)}
  end

  def _build_list service_kits
      parts = bulk_get_part(service_kits)
      combine_part_and_sk(parts, service_kits)
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

  def build service_kits
    service_kits_list = _build_list(service_kits)
    service_kits_list.compact!
    _get_skus(service_kits_list)
  end
end
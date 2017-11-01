class ServiceKitBuilder
  include TurboUtils

  def initialize redis_cache
    @not_external = prepare_manufacturers
    @interchange_getter =  InterchangeGetter.new redis_cache
  end

  def is_external_manufacturer? manufacturer_name
    @not_external.index manufacturer_name
  end


  def _is_ti_part? part
    part[:manfr]== "Turbo International"
  end

  def get_ti_interchange sk
    interchanges  = @interchange_getter.get_cached_interchange(sk[:sku])
    if interchanges
      ti_part  = interchanges.find{|i| i[:manufacturer] == "Turbo International"}
       if ti_part and not  ti_part.empty?
        sk[:ti_part_number] = ti_part[:part_number]
         sk[:tiSku] = ti_part[:id]
       end
    end
  end

  def bulk_get_interchanges service_kits_list
      service_kits_list.map do |sk|
        if sk[:ti_part_number].nil?
              get_ti_interchange(sk)
        end
        sk
      end
  end


  def bulk_get_part service_kits
    ids = service_kits.map{|sk| sk[:kit_id]}
    Part.eager_load(:manfr).find ids
  end

  def bulk_get_ti_parts  service_kits
      oem_sks=  service_kits.select{|sk| not sk[:part_number]}
      ti_ids = oem_sks.map{|osk|  osk[:tiSku]}
       Part.find ti_ids
  end

  def transform_list service_kits
      service_kits.map do |s|
          sk  = {

          }
          if _is_ti_part? s
            sk[:part_number] = nil
            sk[:ti_part_number] = s[:part_number]
            sk[:tiSku] = s[:id]
          else
            sk[:part_number] = s[:part_number]
            sk[:ti_part_number] =  nil
            sk[:sku] =  s[:id]
          end
          sk[:description] = s[:description]
          sk[:manufacturer] = s[:manfr]
          sk[:sku] =  s[:id]
          sk
      end
  end

  def filter_out_ext_manufacturer service_kits
      service_kits.select{|sk| not is_external_manufacturer?(sk)}
  end

  def build service_kits
    service_kits_list = transform_list(service_kits)
    bulk_get_interchanges(service_kits_list)
  end
end
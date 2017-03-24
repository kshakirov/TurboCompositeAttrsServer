class WhereUsedAttrReader
  include TurboUtils

  def initialize
    @not_external = prepare_manufacturers
  end

  def is_external_manufacturer? manufacturer_name
    @not_external.index manufacturer_name
  end

  def get_attribute id
    vw = VWhereUsed.where(principal_id: id)
    response = {}
    if vw.size > 0
      vw.each do |v|
        unless  is_external_manufacturer? v.manufacturer
          aggregate_turbo_part_numbers response, get_main_fields(v)
        end
      end
      response
    else
      nil
    end
  end


  def get_main_fields item
    main = {:sku => item.sku,
            :manufacturer => item.manufacturer,
            :partNumber => item.part_number,
            :tiSku => item.ti_sku,
            :tiPartNumber => item.ti_part_number,
            :partType => item.part_type,
            :turboType => item.turbo_type,
            :turboPartNumbers => item.turbo_part_number,
    }

  end

  def aggregate_turbo_part_numbers response, item_new
    if response.has_key? item_new[:sku]
      response[item_new[:sku]][:turboPartNumbers].push item_new[:turboPartNumbers]
    else
      response[item_new[:sku]] = item_new
      response[item_new[:sku]][:turboPartNumbers] = [item_new[:turboPartNumbers]]

    end
  end
end
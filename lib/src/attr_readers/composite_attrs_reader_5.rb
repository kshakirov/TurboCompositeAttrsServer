class CompositAttrsReader

  def adjuct_sk_group_price sks, group_id
    unless sks.nil?
      sks.each_with_index do |value, index|
        unless value[:prices].nil?
          sks[index][:prices] = value[:prices][group_id]
        end
      end
    end
  end

  def remove_sk_price sks
    unless sks.nil?
      sks.each_with_index do |value,index|
        sks[index][:prices] = 'login'
      end
    end
  end


  def add_prices_to_sk_response sks, prices
    sks.each_with_index  do |sk, index|
      prices.each do |price|
        if price['partId'] == sk[:sku]
          sks[index][:prices] = price['prices']
        end
      end
    end
  end


  def _get_ti_part_number sku
    unless sku.nil?
      part = Part.find  sku
      part.manfr_part_num
    end
  end

  def add_standard_attrs_2_sk service_kits
    if not service_kits.nil?
      ids = []
      service_kits.each_with_index do |value, index|
        part = Part.find value[:sku]
        ids.push value[:sku]
        service_kits[index][:part_number] = part.manfr_part_num
        service_kits[index][:ti_part_number] = _get_ti_part_number(value[:tiSku])
        service_kits[index][:description] = part.description
      end
      add_prices_to_sk_response(service_kits, get_prices(ids))
    else
      nil
    end

  end


  def get_cached_sk sku
    response = @redis_cache.get_cached_response sku, 'service_kits'

    if response
      response
    else
      service_kits = @service_kits.get_attribute sku
      add_standard_attrs_2_sk service_kits
      @redis_cache.set_cached_response sku, 'service_kits', service_kits
      service_kits
    end
  end




  def get_service_kits sku, id
    group_id = @decriptor.get_customer_group id
    service_kits = get_cached_sk sku
    if group_id=='no stats'
      remove_sk_price service_kits
    else
      adjuct_sk_group_price service_kits, @group_prices_map[group_id]
    end

  end
end
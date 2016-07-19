class CompositAttrsReader


  def adjuct_bom_group_price boms, group_id
    unless boms.nil?
      boms.each_with_index do |value, index|
        unless value[:prices].nil?
          boms[index][:prices] = value[:prices][group_id]
        end
      end
    end
  end

  def remove_bom_price boms
    unless boms.nil?
      boms.each_with_index do |value,index|
        boms[index][:prices] = 'login'
      end
    end
  end

  def add_ti_part_number ti_sku
    ti_part_numbers = []
    if ti_sku.size > 0
      ti_sku.each do |sku|
        if sku
          part = Part.find sku
          ti_part_numbers.push(part.manfr_part_num)
        end
      end
    end
    ti_part_numbers
  end


  def add_prices_to_bom_response boms, prices
    boms.each_with_index  do |bom, index|
      prices.each do |price|
        if price['partId'] == bom[:sku]
          boms[index][:prices] = price['prices']
        end
      end
    end
  end


  def add_standard_attrs_2_bom boms
    if not boms.nil?
      ids = []
      boms.each_with_index do |bom, index|
        part = Part.find bom[:sku]
        ids.push bom[:sku]
        boms[index][:description] = part.description
        boms[index][:part_type] = part.part_type.name
        boms[index][:part_number] = part.manfr_part_num
        boms[index][:ti_part_number] = add_ti_part_number(boms[index][:ti_part_sku])
        boms[index][:name] = part.name || boms[index][:part_type] + '-' + boms[index][:part_number]

      end
      add_prices_to_bom_response(boms, get_prices(ids))
      boms
    else
      nil
    end

  end


  def _get_bom_without_prices sku
    boms = @bom_reader.get_attribute sku
    add_standard_attrs_2_bom boms
  end


  def _get_bom_with_prices sku, id
    group_id = @decriptor.get_customer_group id
    boms = @bom_reader.get_attribute sku
    add_standard_attrs_2_bom boms
    if group_id=='no stats'
      remove_bom_price boms
    else
      adjuct_bom_group_price boms, @group_prices_map[group_id]
    end
  end

  def get_bom_attribute sku, id
    if id.nil?
      _get_bom_without_prices sku
    else
      _get_bom_with_prices sku, id
    end
  end
end
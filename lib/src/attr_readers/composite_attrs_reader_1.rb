class CompositAttrsReader


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
      #add_prices_to_response(boms, get_prices(ids))
      boms
    else
      nil
    end

  end


  def get_bom_attribute sku, id=''
    group_id = @decriptor.get_customer_group id
    boms = @bom_reader.get_attribute sku
    add_standard_attrs_2_bom boms
  end
end
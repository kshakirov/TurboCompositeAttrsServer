class CompositAttrsReader


  def add_standard_attrs_2_interchs (interchanges)
    if not interchanges.nil?
      ids = []
      interchanges.each_with_index do |interchange, index|
        part = Part.find interchange[:id]
        ids.push interchange[:id]
        interchanges[index][:description] = part.description
        interchanges[index][:part_number] = part.manfr_part_num
      end
      #add_prices_to_response(boms, get_prices(ids))
      interchanges
    else
      nil
    end

  end


  def get_interchange_attribute sku, id
    group_id = @decriptor.get_customer_group id
    interchanges = @interchange_reader.get_attribute sku
    add_standard_attrs_2_interchs interchanges
  end

end
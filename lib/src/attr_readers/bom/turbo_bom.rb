module TurboCompositeAttrs

  def get_bom_item_prices bom, prices
    price = prices.select{|p| p and p[:partId] == bom[:sku]}
    unless price.empty?
      bom[:prices] = price.first[:prices]
    end
  end


  def add_prices_to_boms_list boms, prices
    boms.map  do |bom|
      get_bom_item_prices(bom, prices)
      bom
    end
  end

  def get_boms_ids bom_list
    bom_list.compact!
    bom_list.map{ |b| b[:sku] }

  end
end
class StandardAttrsReader
  def initialize
    @price_reader = PriceAttrReader.new
  end

  def get_prices ids
    @price_reader.get_attribute ids
  end

  def add_prices_to_response response, prices
    response.each do |key, value|
      prices.each do |price|
        if price['partId'] == key
          response[key][:prices] = price['prices']
        end
      end
    end
  end

  def add_standard_attrs_2_wu where_useds
    ids = []
    where_useds.each do |key, value|
      part = Part.find value[:sku]
      ids.push value[:sku]
      where_useds[key][:description] = part.description
    end
    add_prices_to_response(where_useds, get_prices(ids))

  end
end
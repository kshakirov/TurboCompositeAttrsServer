class WhereUsedPriceManager
  def initialize
    @group_price = GroupPrices.new
  end

  def add_group_price where_useds, id
    group_id = @group_price.prices[id]
    if where_useds
      where_useds.each do |key, value|
        unless value[:prices].nil?
          where_useds[key][:prices] = value[:prices][group_id.to_sym]
        end
      end
    end
  end

  def remove_price where_useds
    if where_useds
      where_useds.each do |key, value|
        where_useds[key][:prices] = 'login'
      end
    end
  end
end
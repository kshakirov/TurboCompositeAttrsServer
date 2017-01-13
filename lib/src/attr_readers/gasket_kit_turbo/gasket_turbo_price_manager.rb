class GasketTurboPriceManager

  def initialize
    @group_price = GroupPrices.new
  end

  def add_group_price turbo, id
    group_id = @group_price.prices[id]
    unless turbo.nil?
        if  turbo[:prices]
          turbo[:prices] = turbo[:prices][group_id.to_sym]
        end
    end
    turbo
  end

  def remove_price turbo
    unless turbo.nil?
        turbo[:prices] = 'login'
    end
    turbo
  end
end
class GasketTurboPriceManager

  def initialize
    @group_price = GroupPrices.new
  end

  def add_group_price turbo, id
    if turbo
        if  turbo[:prices]
          turbo[:prices] = turbo[:prices][:prices][id.to_sym]
        end
    end
    turbo
  end

  def remove_price turbo
    if turbo
        turbo[:prices] = 'login'
    end
    turbo
  end
end
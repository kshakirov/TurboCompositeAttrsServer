class GasketKitPriceManager

  def initialize
    @group_price = GroupPrices.new
  end

  def add_group_price turbos, id
    if turbos
      turbos.each do |value|
        if value[:prices]
          value[:prices] = value[:prices][id.to_sym]
        end
      end
    end
  end

  def remove_price turbos
    if turbos
      turbos.each do |turbo|
        turbo[:prices] = 'login'
      end
    end
  end
end
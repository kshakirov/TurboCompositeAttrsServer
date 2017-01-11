class GasketKitPriceManager

  def initialize
    @group_price = GroupPrices.new
  end

  def add_group_price turbos, id
    group_id = @group_price.prices[id]
    unless boms.nil?
      turbos.each do |value|
        unless value[:prices].nil?
          value[:prices] = value[:prices][group_id.to_sym]
        end
      end
    end
  end

  def remove_price turbos
    unless turbos.nil?
      turbos.each do |turbo|
        turbo[:prices] = 'login'
      end
    end
  end
end
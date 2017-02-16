class BomPriceManager
  def initialize
    @group_price = GroupPrices.new
  end
  def add_group_price boms, id
    unless boms.nil?
      boms.each_with_index do |value, index|
        unless value[:prices].nil?
          boms[index][:prices] = value[:prices][id.to_sym]
        end
      end
    end
  end

  def remove_bom_price boms
    unless boms.nil?
      boms.each_with_index do |value, index|
        boms[index][:prices] = 'login'
      end
    end
  end
end
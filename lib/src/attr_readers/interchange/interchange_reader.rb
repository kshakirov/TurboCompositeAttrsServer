class InterchangeReader
  include TurboUtils
  def initialize
    @not_external = prepare_manufacturers
  end

  def is_external_manufacturer? manufacturer_name
    @not_external.index manufacturer_name
  end

  def get_attribute id
    response = []
    ints = Vint.where(part_id: id)
    ints.each do |int|
      unless is_external_manufacturer?(int.i_manufacturer)
        response.push({:id => int.i_part_id, :manufacturer => int.i_manufacturer})
      end
    end
    response
  end
end
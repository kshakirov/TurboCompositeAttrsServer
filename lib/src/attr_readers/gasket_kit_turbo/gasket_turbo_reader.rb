class GasketTurboReader

  include TurboUtils

  def initialize redis_cache
    @interchange_getter = InterchangeGetter.new redis_cache
  end

  private
  def get_gasket_kit_id id
    begin
      part = Turbo.find id
      part.gasket_kit_id
    rescue Exception => e
      false
    end
  end

  def get_gasket_kit gasket_kit_id
    unless gasket_kit_id.nil?
      gasket_kit = Part.find gasket_kit_id
      interchanges = @interchange_getter.get_interchange_attribute(gasket_kit_id)
      g = {
          id: gasket_kit_id,
          ti_id: get_ti_part_id(gasket_kit, interchanges),
          part_number: get_oe_part_number(gasket_kit),
          ti_part_number: get_ti_part_number(gasket_kit, interchanges),
          description: gasket_kit.description,
          manufacturer: gasket_kit.manfr.name,
          prices: nil,
          interchanges: interchanges

      }
      rid_of_ti_interchange(g, interchanges)
    end
  end

  public
  def get_attribute id
    gasket_kit_id = get_gasket_kit_id(id)
    if gasket_kit_id
      get_gasket_kit(gasket_kit_id)
    end
  end
end
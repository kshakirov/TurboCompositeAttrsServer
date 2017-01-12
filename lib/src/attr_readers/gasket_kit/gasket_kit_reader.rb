class GasketKitReader
  extend Forwardable
  def_delegator :@interchange_getter, :get_interchange_attribute, :get_interchange_attribute
  def initialize
      @interchange_getter = InterchangeGetter.new
  end

  private
  def get_turbo_type turbo
    turbo.turbo_model.turbo_type.name
  end

  def is_ti_manufactured? part
      part.manfr.name == 'Turbo International'
  end

  def get_ti_part_number part
    if is_ti_manufactured? part
      part.manfr_part_num
    end
  end

  def get_oe_part_number part
    unless is_ti_manufactured? part
      part.manfr_part_num
    end
  end

  def get_parts_from_turbo turbos
    turbos.map { |turbo|
      part = Part.find turbo.part_id
      {
          id: part.id, manufacturer: part.manfr.name,
          part_number: get_oe_part_number(part),
          ti_part_number: get_ti_part_number(part),
          description: part.description,
          turbo_type: get_turbo_type(turbo),
          interchanges:   get_interchange_attribute(part.id)
      }
    }
  end

  def get_interchanges id
    skus = get_interchange_attribute(id)
    unless skus.class.name == "Array"
      skus = []
    end
    skus.push({:id => id})
    skus
  end

  public

  def get_attribute id

    skus = get_interchanges(id)
    turbos =skus.map{|sku| Turbo.where(gasket_kit_id: sku[:id])}
    turbos = turbos.map{|turbo| get_parts_from_turbo(turbo)}
    turbos.flatten
  end
end
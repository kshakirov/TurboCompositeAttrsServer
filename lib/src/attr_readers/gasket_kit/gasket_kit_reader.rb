class GasketKitReader


  def get_turbo_type turbo
    turbo.turbo_model.turbo_type.name
  end

  def get_parts_from_turbo turbos
    turbos.map { |turbo|
      part = Part.find turbo.part_id
      {
          id: part.id, manufacturer: part.manfr.name,
          part_number: part.manfr_part_num,
          description: part.description,
          turbo_type: get_turbo_type(turbo)
      }
    }
  end


  def get_attribute id
    response = []
    turbos = Turbo.where(gasket_kit_id: id)
    get_parts_from_turbo(turbos)
  end
end
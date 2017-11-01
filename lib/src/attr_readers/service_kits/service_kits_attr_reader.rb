class ServiceKitsAttrReader
    def expand_kits kits
      kits.map do |k|
        {
            id: k.id,
            manfr:  k.manfr.name,
            description: k.description,
            price: nil,
            part_number: k.manfr_part_num
        }
      end
    end
     def get_attribute id
        turbo  = Turbo.eager_load(:turbo_model).find id
        turbo_type_id =  turbo.turbo_model.turbo_type_id
        types = PartTurboType.where(turbo_type_id: turbo_type_id).all
        ids = types.map{|t| t.part_id}
        kits  =Part.eager_load(:manfr).where(id: ids, part_type_id: 3).all
        expand_kits(kits)

  end
end
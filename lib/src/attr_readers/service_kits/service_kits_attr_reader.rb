class ServiceKitsAttrReader
     def get_attribute id
        VpartTurboTypeKits.where(part_id: id).all
  end
end
class VmagmiTiChra < ActiveRecord::Base
  self.table_name = 'vmagmi_ti_chra'
  self.primary_key = 'id'
end

class VWhereUsed < ActiveRecord::Base
  self.table_name = 'vwhere_used'
end

class VmagmiBom < ActiveRecord::Base
  self.inheritance_column = nil
  self.table_name = 'vmagmi_bom'
end

class VmagmiServiceKit < ActiveRecord::Base
  self.table_name = 'vmagmi_service_kits'
end

class VpartTurboTypeKits< ActiveRecord::Base
self.table_name = 'vpart_turbotype_kits'
end

class Vint < ActiveRecord::Base
  self.table_name = 'vint'
end

class VintTi < ActiveRecord::Base
  self.table_name = 'vint_ti'
end


class Vapp < ActiveRecord::Base
  self.table_name = 'vapp'
end


class VbomDescendant < ActiveRecord::Base
  self.inheritance_column = nil
  self.table_name = 'vbom_descendant'
end
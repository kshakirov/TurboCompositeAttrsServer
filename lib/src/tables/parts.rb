class Manfr < ActiveRecord::Base
  self.table_name = 'manfr'
  self.primary_key = "id"
  has_many :turbo_type, class_name: "TurboType"
end


class Part < ActiveRecord::Base
  has_many :salesnotepart, class_name: "Salesnotepart",
           foreign_key: "part_id"
  belongs_to :manfr, class_name: "Manfr",
             foreign_key: 'manfr_id'
  belongs_to :part_type, class_name: "PartType",
             foreign_key: 'part_type_id'
  self.table_name = "part"

  has_many :product_image, class_name: "ProductImage",
           foreign_key: "part_id"
  has_one :bearing_spacer, class_name: "BearingSpacer"


end


class Turbo < ActiveRecord::Base
  self.table_name = 'turbo'
  self.primary_key = "part_id"
  belongs_to :part, class_name: "Part",
             foreign_key: 'part_id'
  belongs_to :turbo_model, class_name: "TurboModel",
             foreign_key: 'turbo_model_id'
end


class TurboType < ActiveRecord::Base
  self.table_name =  'turbo_type'
  self.primary_key = "id"
  belongs_to :manfr, class_name: "Manfr",
             foreign_key: 'manfr_id'


end


class TurboModel < ActiveRecord::Base
  self.table_name =  'turbo_model'
  self.primary_key = "id"

  belongs_to :turbo_type, class_name: "TurboType",
             foreign_key: 'turbo_type_id'
end


class PartType < ActiveRecord::Base
  self.table_name = 'part_type'
  self.primary_key = "id"
end

class BearingSpacer < ActiveRecord::Base
  self.table_name =  'bearing_spacer'
  self.primary_key = "part_id"
  has_one :part, class_name: "Part",
          foreign_key: 'id'
end

class Salesnote < ActiveRecord::Base
  self.table_name = "sales_note"
  def self.recently_commented
    self.find(:all,:conditions => [ 'write_date  > ?', Time.now - 5.years] )
  end
end

class Salesnotepart < ActiveRecord::Base
  #has_ :salesnote, class_name: "Salesnote",
  #        foreign_key: "sales_note_id"
  #self.primary_keys = :sales_note_id, :part_id
  self.table_name = "sales_note_part"
end

class GasketKit < ActiveRecord::Base
  self.table_name ='gasket_kit'
  self.primary_key = "part_id"
end

class StandardOversizePart < ActiveRecord::Base
  self.table_name ='standard_oversize_part'
#  self.primary_key = :standard_oversize_part_id, :oversize_part_id
end

class JournalBearing < ActiveRecord::Base
  self.table_name ='journal_bearing'
  self.primary_key = "part_id"
end

class JournalBearingSpacer < ActiveRecord::Base
  self.table_name ='journal_bearing_spacer'
  self.primary_key = "part_id"
end

class PartAudit < ActiveRecord::Base

end
class BomReader
  def initialize
    @sql_template = ERB.new %q{
  select
      b.parent_part_id AS ancestor_sku
    , bc.parent_part_id as parent_sku
    , bc.child_part_id AS descendant_sku
    , bd.qty AS quantity
    , bd.distance AS distance
    , bd.type
    , pt.value as part_type
    , ppt.value AS part_type_parent
FROM
    bom_descendant bd
    JOIN bom b ON bd.part_bom_id = b.id
    JOIN bom bc ON bd.descendant_bom_id = bc.id

    join part p on p.id = bc.child_part_id
    JOIN part_type pt ON pt.id = p.part_type_id
    left JOIN part_type ppt ON ppt.id = pt.parent_part_type_id
where
    b.parent_part_id = <%= part_id %>
    }.gsub(/\s+/, " ").strip
  end

  def query_db id
    part_id = id
    sql = @sql_template.result(binding)
    ActiveRecord::Base.connection.execute(sql)
  end

  def get_attribute id
    query_db id
  end
end
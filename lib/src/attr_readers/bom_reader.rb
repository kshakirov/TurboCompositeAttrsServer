class BomReader
  def initialize
    @sql_template = ERB.new %q{
    SELECT DISTINCT
      ii2.part_id AS ancestor_sku,
      ii.part_id AS descendant_sku,
      bd.qty AS quantity,
      bd.distance AS distance,
      IF(((ii2.part_id <> b.parent_part_id)
              OR (ii.part_id <> bc.child_part_id)),
          'Interchange',
          bd.type) AS type,
      dppt.value AS part_type_parent,
      IF((db.id IS NOT NULL), 1, 0) AS has_bom,
      ba.child_part_id AS alt_sku,
      bam.id AS alt_mfr_id,
      ip.id AS int_sku
    FROM
        bom_descendant bd
        JOIN bom b ON bd.part_bom_id = b.id
        JOIN interchange_item ii1 ON b.parent_part_id = ii1.part_id
        JOIN interchange_item ii2 ON ii2.interchange_header_id = ii1.interchange_header_id
        JOIN bom bc ON bd.descendant_bom_id = bc.id
        JOIN interchange_item ii3 ON bc.child_part_id = ii3.part_id
        JOIN interchange_item ii ON ii3.interchange_header_id = ii.interchange_header_id

        JOIN part dp ON dp.id = ii.part_id
        JOIN part_type dpt ON dpt.id = dp.part_type_id
        LEFT JOIN part_type dppt ON dppt.id = dpt.parent_part_type_id

        left join
        (bom_alt_item bai
        JOIN bom ba ON ba.id = bai.bom_id
        JOIN part pa ON pa.id = bai.part_id
        JOIN manfr bam ON bam.id = pa.manfr_id) ON bai.bom_id = bd.part_bom_id

        left join
        (interchange_item ii1t
        JOIN interchange_item ii2t ON ii2t.interchange_header_id = ii1t.interchange_header_id AND ii1t.part_id <> ii2t.part_id
        JOIN part ip ON ip.id = ii2t.part_id and ip.manfr_id = 11) on ii1t.part_id = ii.part_id

        LEFT JOIN bom db ON db.parent_part_id = ii.part_id

        left join
        (bom_descendant bdd
                JOIN bom b4 ON bdd.part_bom_id = b4.id and bdd.type = 'direct'
                JOIN bom b4c ON bdd.descendant_bom_id = b4c.id
        ) ON ii2.part_id = b4.parent_part_id
            AND ii.part_id = b4c.child_part_id
            and IF(((ii2.part_id <> b.parent_part_id)
                     OR (ii.part_id <> bc.child_part_id)),
                    'Interchange',
                    bd.type) = 'Interchange'

    WHERE
        ISNULL(bdd.id)
        and ii2.part_id = <%= part_id %>
    }.gsub(/\s+/, " ").strip
  end

  def conv_from_hash_to_array hash
    values = []
    hash.each do |key, value|
      values.push value
    end
    values
  end

  def create_hash bom
    main = {:alt_part_sku => [],
            :distance => bom['distance'],
            :has_bom => bom['has_bom'] == 1 ? true : false,
            :part_type_parent => bom['part_type_parent'],
            :quantity => bom['quantity'],
            :sku => bom['descendant_sku'],
            :ti_part_sku => [bom['int_sku']],
            :type => bom['type']}
  end

  def aggregate_ti_part_skus boms
    hash = {}
    boms.each do |bom|
      if hash.has_key? bom['descendant_sku']
        hash[bom['descendant_sku']][:ti_part_sku].push bom['int_sku']
      else
        hash[bom['descendant_sku']] = create_hash(bom)
      end
    end
    hash
  end

  def prepare_response id
    part_id = id
    sql = @sql_template.result(binding)
    boms = ActiveRecord::Base.connection.execute(sql)
    hash = aggregate_ti_part_skus boms
    conv_from_hash_to_array hash

  end

  def get_attribute id
    prepare_response id

  end
end
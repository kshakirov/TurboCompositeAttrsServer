class StandardOversizeAttrReader
  extend Forwardable
  include CompareSizes
  def_delegator :@interchange_getter, :get_interchange_attribute, :get_interchange_attribute

  def initialize
    @interchange_getter = InterchangeGetter.new
  end

  private
  def _get_interchanges part_ids
    part_ids.map { |id| get_interchange_attribute(id) }
  end

  def get_part_type part
    part.part_type.magento_attribute_set.gsub(/\s+/, "")
  end

  def get_original_part id
    Part.find(id)
  end

  def get_part id, part_type
    klass = Object.const_get(part_type)
    klass.find id
  end

  def is_interchange_ti? interchange
    interchange[:manufacturer]=='Turbo International'
  end

  def find_ti_interchange interchanges
    interchanges.find { |i| is_interchange_ti?(i) }
  end

  def remove_ti_from_interchs sku, interchanges
    interchanges.delete_if { |i| i[:sku] == sku }
  end

  def move_interchange item, interchanges
    interchanges.push({
                          manufacturer: item[:manufacturer],
                          sku: item[:sku],
                          part_number: item[:part_number]
                      })
  end

  def replace_interchange_ti item, interchanges
    interchange = find_ti_interchange(interchanges)
    unless interchange.nil?
      move_interchange(item, interchanges)
      item[:manufacturer] = interchange[:manufacturer]
      item[:sku] =interchange[:id]
      item[:part_number] =interchange[:part_number]
      remove_ti_from_interchs(item[:sku], interchanges)
      item[:interchanges] = interchanges
    end
  end

  def couple_origs_interchs interchanges, compared_parts
    compared_parts.delete(false)
    compared_parts.each_with_index do |cp, index|
      if is_interchange_ti? cp
        cp[:interchanges] = interchanges[index] if cp
      else
        #replace_interchange_ti(cp, interchanges[index]) if cp
        cp[:remove] = true
      end
    end
    compared_parts.delete_if { |cp| cp.key? :remove }
  end

  def create_oversizeds_hashes parts_ids, part, part_type
    interchanges = _get_interchanges(parts_ids)
    interchanges.map! do |i|
      i.map! do |ii|
        ii[:sku] = ii[:id]
        ii
      end
      i
    end
    compared_parts = compare_parts(parts_ids, part, part_type)
    couple_origs_interchs(interchanges, compared_parts)
  end

  def prepare_attribute hashes, original_part
    {
        table: hashes,
        original_part: original_part,
        reference: false
    }
  end

  def _get_attribute id
    original_part = get_original_part(id)
    part_type = get_part_type(original_part)
    part = get_part(id, part_type)
    unless part_type.nil?
      records = StandardOversizePart.where(standard_part_id: id)
      if records and records.size > 0
        prepare_attribute(create_oversizeds_hashes(
                              records.map { |r| r.oversize_part_id }, part, part_type),
                          do_original_part(part, part_type, original_part))
      end
    end
  end

  def _sort_by_multiple_fields table
    table.sort_by do |row|
      [row[:maxOuterDiameter], row[:maxInnerDiameter], row[:part_number]]
    end
  end

  public
  def get_attribute id
    hashe =_get_attribute(id)
    if not hashe.nil? and hashe.has_key? :table and not hashe[:table].nil?
      hashe[:table] = _sort_by_multiple_fields(hashe[:table])
    end
    hashe
  end

end
class StandardOversizeAttrReader

  extend Forwardable
  def_delegator :@interchange_getter, :get_interchange_attribute, :get_interchange_attribute

  def initialize
    @interchange_getter = InterchangeGetter.new
  end

  private
  def _get_interchanges part_ids
    interchanges = part_ids.map { |id| get_interchange_attribute(id) }
    interchanges.flatten!.map { |i| i[:id] }
  end

  def _compare_sizes part, original_part
    unless original_part.maxOuterDiameter == part.maxOuterDiameter and
        original_part.minOuterDiameter == part.minOuterDiameter and
        original_part.maxInnerDiameter == part.maxInnerDiameter and
        original_part.minInnerDiameter == part.minInnerDiameter
      return {
          maxOuterDiameter: original_part.maxOuterDiameter.to_f - part.maxOuterDiameter.to_f,
          minOuterDiameter: original_part.minOuterDiameter.to_f - part.minOuterDiameter.to_f,
          minInnerDiameter: original_part.minInnerDiameter.to_f - part.minInnerDiameter.to_f,
          maxInnerDiameter: original_part.minInnerDiameter.to_f - part.minInnerDiameter.to_f
      }

    end
    false
  end

  def compare_parts ids, original_part, part_type
    ids.map do |id|
      part = JournalBearing.find id
      _compare_sizes(part, original_part)
    end
  end

  def get_part_and_type id
    begin
      return Part.find(id).part_type.magento_attribute_set.gsub(/\s+/, ""),
          JournalBearing.find(id)
    rescue Exception => e
      nil
    end
  end

  def _get_attribute id
    part_type, part = get_part_and_type(id)
    unless part_type.nil?
      records = StandardOversizePart.where(standard_part_id: id)
      if records and records.size > 0
        parts_ids = records.map { |r| r.oversize_part_id }
        interchanges = _get_interchanges(parts_ids)
        compare_parts(parts_ids + interchanges, part, part_type)
      end
    end
  end

  public
  def get_attribute id
    _get_attribute(id)
  end

end
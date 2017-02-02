class StandardOversizeAttrReader
  extend Forwardable
  include CompareSizes
  def_delegator :@interchange_getter, :get_interchange_attribute, :get_interchange_attribute

  def initialize
    @interchange_getter = InterchangeGetter.new
  end

  private
  def _get_interchanges part_ids
    interchanges = part_ids.map { |id| get_interchange_attribute(id) }
#    interchanges.flatten!
  end

  def get_part_type id
    begin
      Part.find(id).part_type.magento_attribute_set.gsub(/\s+/, "")
    rescue Exception => e
      nil
    end
  end

  def get_part id, part_type
    klass = Object.const_get(part_type)
    klass.find id
  end

  def couple_origs_interchs interchanges, compared_parts
    compared_parts.delete(false)
    compared_parts.each_with_index { |cp, index|
      cp[:interchanges] = interchanges[index] if cp
      cp
    }
  end

  def create_oversizeds_hashes parts_ids, part, part_type
    interchanges = _get_interchanges(parts_ids)
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
    part_type = get_part_type(id)
    part = get_part(id, part_type)
    unless part_type.nil?
      records = StandardOversizePart.where(standard_part_id: id)
      if records and records.size > 0
        prepare_attribute(create_oversizeds_hashes(
            records.map { |r| r.oversize_part_id }, part, part_type),
            do_original_part(part, part_type))
      end
    end
  end

  public
  def get_attribute id
    _get_attribute(id)
  end

end
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
    interchanges.flatten!.map { |i| i[:id] }
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

  def _get_attribute id
    part_type = get_part_type(id)
    part = get_part(id, part_type)
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
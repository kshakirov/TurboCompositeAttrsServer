class OversizeAttrReader
  extend Forwardable
  include CompareSizes
  def_delegator :@interchange_getter, :get_interchange_attribute, :get_interchange_attribute
  def_delegator :@standard_oversize_getter, :get_standard_oversize, :get_standard_oversize

  def initialize
    @standard_oversize_getter = StandardOversizeGetter.new
    @interchange_getter = InterchangeGetter.new
  end

  private

  def find_direct_reference id, attribute
    row = attribute[:table].select { |row| row[:sku] == id }
    row.first[:part_number]
  end

  def find_interchange_reference id, attribute
    row = attribute[:table].select do |row|
      row[:interchanges].find(false) do |i|
        i[:id] ==id
      end
    end
    row.first[:part_number]
  end

  def prepare_attribute id, standard_part_id
    attribute = get_standard_oversize(standard_part_id)
    attribute[:reference] = find_direct_reference(id, attribute)
    attribute
  end

  def search_interchanges id

  end

  def _get_attribute id
    records = StandardOversizePart.where(oversize_part_id: id)
    if records and records.size >0
      prepare_attribute(id, records.first.standard_part_id)
    else
      search_interchanges(id)
    end
  end

  public
  def get_attribute id
    _get_attribute(id)
  end

end
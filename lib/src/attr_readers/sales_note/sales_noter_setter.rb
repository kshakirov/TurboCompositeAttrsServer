class SalesNoteSetter

  def initialize redis_cache
    @sales_note_reader = SalesNoteAttrReader.new
    @redis_cache = redis_cache
  end

  def add_part_number notes, sku
    part = Part.find sku
    notes.map do |n|
      n[:part_number] = part.manfr_part_num
      n
    end
  end

  def get_sales_notes sku
    @sales_note_reader.get_attribute(sku)
  end

  def cache_sales_note sku, notes
    @redis_cache.set_cached_response sku, 'sales_note', notes
  end

  def set_sales_note_attribute sku
    notes = get_sales_notes sku
    notes = add_part_number(notes, sku)
    cache_sales_note sku, notes
  end
end
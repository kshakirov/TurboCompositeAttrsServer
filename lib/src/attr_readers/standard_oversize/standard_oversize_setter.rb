class StandardOversizeSetter
  def initialize redis_cache
    @standard_oversize_reader = StandardOversizeAttrReader.new redis_cache
    @redis_cache = redis_cache
  end

  private

  def is_valid_oversize? oversize
    oversize.class.name == "Hash" and
        oversize.key? :table and oversize[:table].class.name == "Array"
  end

  def process_oversizeds standard_oversize
    standard_oversize[:table].each do |row|
      oversize = standard_oversize.deep_dup
      oversize[:reference] = row[:sku]
      set_oversizeds(oversize, row)
    end
  end

  def process_standard_interchanges standard_oversize
    standard_oversize[:original_part][:interchanges].each do |i|
      @redis_cache.set_cached_response(i[:id], 'standard_oversize', standard_oversize)
    end
  end

  def set_oversizeds oversize, row
    @redis_cache.set_cached_response(oversize[:reference], 'standard_oversize', oversize)
    if row.key? :interchanges
      row[:interchanges].each do |int|
        @redis_cache.set_cached_response(int[:id], 'standard_oversize', oversize)
      end
    end
  end

  def cache_standard_oversize sku
    standard_oversize = @standard_oversize_reader.get_attribute(sku)
    if is_valid_oversize?(standard_oversize)
      process_oversizeds(standard_oversize)
      process_standard_interchanges(standard_oversize)
    end
    unless standard_oversize.nil?
      @redis_cache.set_cached_response(sku, 'standard_oversize', standard_oversize)
    end
  end

  public
  def set_std_oversize_attribute sku
    cache_standard_oversize sku
    "Sku [#{sku}]  Finished"
  end
end
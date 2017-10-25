class SalesNoteBatchGetter
  def initialize redis_cache=RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @redis_cache = redis_cache
  end

  def get_cached_notes skus
    skus.map do |s|
      nt = @redis_cache.get_cached_response s, 'sales_note'
      {
          sku: s,
          note: nt
      }
    end
  end

  def create_notes_array skus
    cached_notes = get_cached_notes(skus) || []
    cached_notes.map do |cn|
      cn[:note].map do |n|
        n[:sku] = cn[:sku]
        n
      end
    end
  end

  def get_sales_note_attributes skus
    notes_array = create_notes_array(skus) || []
    notes_array.flatten
  end
end
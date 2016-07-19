class CompositAttrsReader

  def get_cached_sn sku
    response = @redis_cache.get_cached_response sku, 'sales_note'

    if response
      response
    else
      sns = @sales_note_reader.get_attribute sku
      @redis_cache.set_cached_response sku, 'sales_note', sns
      sns
    end
  end

  def get_sales_notes sku
    get_cached_sn sku
  end
end
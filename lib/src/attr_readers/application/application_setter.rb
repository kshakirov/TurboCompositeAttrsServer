class ApplicationSetter
  def initialize redis_cache
    @application_reader = ApplicationReader.new redis_cache
    @redis_cache =  redis_cache
  end
  private
  def cache_application sku, applications
    @redis_cache.set_cached_response sku, 'application',applications
  end
  public
  def set_application_attribute sku
    applications = @application_reader.get_attribute sku
    cache_application sku, applications
  end
end
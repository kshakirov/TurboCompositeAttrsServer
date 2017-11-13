class ApplicationSetter
  def initialize redis_cache
    @application_reader = ApplicationReader.new redis_cache
    @redis_cache =  redis_cache
  end
  private
  def cache_application sku, applications
    @redis_cache.set_cached_response sku, 'application',applications
  end

  def sort_apps applications
    applications.sort do  |a, b|
      [
          a[:make].to_s, a[:model].to_s,a[:year].to_s, a[:engine_size].to_s
      ]<=>
          [
              b[:make].to_s, b[:model].to_s,b[:year].to_s, b[:engine_size].to_s
          ]
    end
  end

  public
  def set_application_attribute sku
    applications = @application_reader.get_attribute sku
    applications = sort_apps applications
    cache_application sku, applications
  end
end
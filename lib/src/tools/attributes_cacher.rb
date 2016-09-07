class AttributesCacher
  def initialize
    redis_client = RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @where_used_setter = WhereUsedSetter.new redis_client
    @bom_setter = BomSetter.new redis_client
    @interchange_setter = InterchangeSetter.new redis_client
    @service_kit_setter = ServiceKitSetter.new redis_client
    @sales_note_setter = SalesNoteSetter.new redis_client
  end

  def put sku
    @where_used_setter.set_where_used_attribute sku
    @bom_setter.set_bom_attribute sku
    @interchange_setter.set_interchange_attribute sku
    @service_kit_setter.set_service_kit_attribute sku
    @sales_note_setter.set_sales_note_attribute sku
  end
end
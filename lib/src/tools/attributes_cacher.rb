class AttributesCacher
  def initialize
    redis_client = RedisCache.new(Redis.new(:host => "redis", :db => 3))
    @where_used_setter = WhereUsedSetter.new redis_client
    @bom_setter = BomSetter.new redis_client
    @interchange_setter = InterchangeSetter.new redis_client
    @kit_matrix_setter = KitMatrixSetter.new redis_client
  end
  def put sku
    #@where_used_setter.set_where_used_attribute sku
    #@bom_setter.set_bom_attribute sku
   # @interchange_setter.set_interchange_attribute sku
    @kit_matrix_setter.set_kit_matrix_attribute  sku
    # @stdreader.get_service_kits sku, 'sVrXIqos994v0pkehHI28Q=='
    # @stdreader.get_sales_notes sku
    # @stdreader.set_major_component sku,'sVrXIqos994v0pkehHI28Q=='
  end
end
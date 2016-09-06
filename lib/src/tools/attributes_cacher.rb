class AttributesCacher
  def initialize
    @stdreader = CompositAttrsReader.new
    @where_used_setter = WhereUsedSetter.new
    @bom_setter = BomSetter.new
  end
  def put sku
    #@where_used_setter.set_where_used_attribute sku
    @bom_setter.set_bom_attribute sku
    # @stdreader.get_interchange_attribute 6392, 'sVrXIqos994v0pkehHI28Q=='
    # @stdreader.get_kit_matrix sku
    # @stdreader.get_service_kits sku, 'sVrXIqos994v0pkehHI28Q=='
    # @stdreader.get_sales_notes sku
    # @stdreader.set_major_component sku,'sVrXIqos994v0pkehHI28Q=='
  end
end
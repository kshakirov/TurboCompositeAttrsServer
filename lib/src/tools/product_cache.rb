class ProductCache
  def initialize
    @stdreader = CompositAttrsReader.new
  end
  def get_cached_attributes sku
    @stdreader.get_where_used_attribute sku, 'sVrXIqos994v0pkehHI28Q=='
    @stdreader.get_bom_attribute sku, 'sVrXIqos994v0pkehHI28Q=='
    @stdreader.get_interchange_attribute 6392, 'sVrXIqos994v0pkehHI28Q=='
    @stdreader.get_kit_matrix sku
    @stdreader.get_service_kits sku, 'sVrXIqos994v0pkehHI28Q=='
    @stdreader.get_sales_notes sku
    @stdreader.get_major_component sku,'sVrXIqos994v0pkehHI28Q=='
  end
end
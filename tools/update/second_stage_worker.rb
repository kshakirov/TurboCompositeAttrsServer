class SecondStageWorker
  include Celluloid

  def initialize redis_cache, graph_service_url
    @bom_worker = BomSetter.new redis_cache,graph_service_url
    @where_worker = WhereUsedSetter.new redis_cache,graph_service_url
    @gasket_kit_setter = GasketKitSetter.new redis_cache
  end

  def set_attribute sku
    begin
    @bom_worker.set_bom_attribute sku
    @where_worker.set_where_used_attribute sku
    @gasket_kit_setter.set_gasket_kit_attribute sku
    rescue StandardError => se
      puts "Sku #{sku} failed"
      p se.message
    end
    ActiveRecord::Base.clear_active_connections!
    "Future Finished sku [#{sku}]"
  end
end
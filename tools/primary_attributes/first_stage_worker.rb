class FirstStageWorker
  include Celluloid

  def initialize redis_cache, graph_service_url
    @interchange_worker = InterchangeSetter.new redis_cache,graph_service_url
    @sales_notes_worker = SalesNoteSetter.new redis_cache
  end

  def set_attribute sku
    @interchange_worker.set_interchange_attribute sku
    @sales_notes_worker.set_sales_note_attribute sku
    ActiveRecord::Base.clear_active_connections!
    "Future Finished sku [#{sku}]"
  end
end
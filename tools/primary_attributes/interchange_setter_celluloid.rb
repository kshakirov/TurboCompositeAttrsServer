class PrimaryAttributeWorker
  include Celluloid
  def initialize
    @interchange_worker = InterchangeSetter.new
    @bom_worker = BomSetter.new
    @where_worker = WhereUsedSetter.new
    @service_kit_worker = ServiceKitSetter.new
    @sales_notes_worker = SalesNoteSetter.new
  end
  def set_attribute sku
    @interchange_worker.set_interchange_attribute sku
    @bom_worker.set_bom_attribute sku
    @where_worker.set_where_used_attribute sku
    @service_kit_worker.set_service_kit_attribute sku
    @sales_notes_worker.set_sales_note_attribute sku
    ActiveRecord::Base.clear_active_connections!
    "Future Finished sku [#{sku}]"
  end
end
class BomWorker
  include Celluloid
  def initialize
    @bom_worker = BomSetter.new
    @service_kit_worker = ServiceKitSetter.new
  end
  def set_attribute sku
    @bom_worker.set_bom_attribute sku
    @service_kit_worker.set_service_kit_attribute sku
    ActiveRecord::Base.clear_active_connections!
    puts "Future Finished sku [#{sku}]"
  end
end
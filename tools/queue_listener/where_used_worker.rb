class WhereUsedWorker
  include Celluloid
  def initialize
    @where_worker = WhereUsedSetter.new
  end
  def set_attribute sku
    @where_worker.set_where_used_attribute sku
    ActiveRecord::Base.clear_active_connections!
    puts "Future Finished sku [#{sku}]"
  end
end
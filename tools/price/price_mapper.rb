require_relative '../mappers_helper'
require_relative 'price_cache_worker'
require_relative 'price_audit_updater'


unless  ENV['RACK_ENV']
  puts "SET RACK_ENV=[production,development,staging,test  then try again .."
  exit(1)
end


@price_worker = PriceCacheWorker.pool
@price_audit_updater = PriceAuditUpdater.new

counter = 1

def make_future ids
  @price_worker.future.put(ids)
end

def map_parts_2_grp_ids
  Part.joins(:manfr).where(manfr: {name: 'Turbo International'}).
      find_in_batches(batch_size: 100).map do |group|
    group.map { |part| part.id }
  end
end

def  map_ids_2_futures grp_ids
  grp_ids.map do |ids|
    make_future(ids)
  end
end

def get_unresolved_futures futures
  futures.select{|future|  not future.ready?}
end

def are_futures_ready?  unresolved_futures
  puts "Unresolved Futures [#{unresolved_futures.size}]"
  unresolved_futures.size == 0
end

def resolve_futures futures
  futures.each{|future|
     @price_audit_updater.update_audit_table (future.value)
  }
end

grp_ids =  map_parts_2_grp_ids
futures = map_ids_2_futures(grp_ids)

timers = Timers::Group.new

every_five_seconds = timers.every(10) {
  puts "Another #{10 * counter} seconds"
  if are_futures_ready? get_unresolved_futures(futures)
    #resolve_futures(futures)
    timers.cancel
    exit(0)
  end
  counter += 1
}
loop { timers.wait }
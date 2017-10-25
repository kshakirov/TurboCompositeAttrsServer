require_relative '../mappers_helper'
require_relative 'worker_classes'


graph_service_url = get_service_configuration

worker = PrimaryAttributeWorker.pool args: [graph_service_url]
futures = map_specific_parts(worker)
ActiveRecord::Base.clear_active_connections!
counter = 1
interval = 5
initial_size = futures.size

timers = Timers::Group.new

every_ten_seconds = timers.every(interval) {
  processing_time = interval * counter
  puts "Another #{processing_time} seconds"
  futures = remove_resolved_futures futures
  if are_futures_ready?(futures, initial_size, processing_time)
    puts "Update Finished"
    timers.cancel
    exit(0)
  end
  counter += 1
}
loop { timers.wait }

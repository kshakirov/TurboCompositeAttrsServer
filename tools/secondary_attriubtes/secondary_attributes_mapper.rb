require_relative '../mappers_helper'
require_relative 'worker_classes'



def make_future id
  @worker.future.set_attribute(id)
end

def map_specific_parts
  Part.all.map do |part|
    puts "Created Future for [#{part.id}]"
    make_future(part.id)
  end
  ActiveRecord::Base.clear_active_connections!
end

def remove_resolved_futures futures
  futures.select do |future|
    if future.ready?
      future.value
      false
    else
      true
    end
  end
end

def are_futures_ready? unresolved_futures,  initial_size, processing_time
  puts "Unresolved Futures [#{unresolved_futures.size}]"
  processed_futures = initial_size - unresolved_futures.size
  puts "Resolved [#{processed_futures}], Latency [#{processing_time.to_f/processed_futures}] "
  unresolved_futures.size == 0
end



@worker = SecondaryAttributeWorker.pool
futures = map_specific_parts
counter = 1
interval = 2
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

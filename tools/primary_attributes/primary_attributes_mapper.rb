require_relative '../mappers_helper'
require_relative 'interchange_setter_celluloid'
def make_future id
  @interchange_worker.future.set_interchange_attribute(id)
end

def map_specific_parts
  Part.limit(100).map do |part|
    puts "Created Future for [#{part.id}]"
    make_future(part.id)
  end
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


@interchange_worker = InterchangeSetter.pool
futures = map_specific_parts
counter = 1

initial_size = futures.size

timers = Timers::Group.new

every_ten_seconds = timers.every(10) {
  processing_time = 10 * counter
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

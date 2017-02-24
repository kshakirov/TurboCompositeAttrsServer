require_relative '../mappers_helper'
require_relative 'standard_oversize_celluloid'

def make_future id
  @std_ovrsize_worker.future.set_std_oversize_attribute(id)
end

def map_specific_parts
  Part.joins(:part_type).where(part_type: {name: ['Journal Bearing', 'Journal Bearing Spacer', 'Piston Ring']}).
      map do |part|
    puts "Created Future for [#{part.id}]"
    make_future(part.id)
  end
end

def remove_resolved_futures futures
  futures.select do |future|
    if future.ready?
      puts future.value
      false
    else
      true
    end
  end
end

def are_futures_ready? unresolved_futures
  puts "Unresolved Futures [#{unresolved_futures.size}]"
  unresolved_futures.size == 0
end


@std_ovrsize_worker = StandardOversizeSetter.pool
futures = map_specific_parts
counter = 0

timers = Timers::Group.new

every_ten_seconds = timers.every(10) {
  puts "Another #{10 * counter} seconds"
  futures = remove_resolved_futures futures
  if are_futures_ready?(futures)
    puts "Done"
    timers.cancel
    exit(0)
  end
  counter += 1
}
loop { timers.wait }

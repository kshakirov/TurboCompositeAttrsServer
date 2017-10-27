def make_price_future ids
  @price_worker.future.put(ids)
end

def batch_get_ti_parts_ids
  Part.joins(:manfr).where(manfr: {name: 'Turbo International'}).
      find_in_batches(batch_size: 100).map do |group|
    group.map do |part|
      part.id
    end
  end
end

def create_futures grp_ids
  grp_ids.map do |ids|
    make_price_future(ids)
  end
end

def get_unresolved_futures futures
  futures.select { |future| not future.ready? }
end

def are_futures_ready? unresolved_futures
  puts "Unresolved Futures [#{unresolved_futures.size}]"
  unresolved_futures.size == 0
end

def resolve_futures futures
  futures.each { |future|
    @price_audit_updater.update_audit_table (future.value)
  }
end
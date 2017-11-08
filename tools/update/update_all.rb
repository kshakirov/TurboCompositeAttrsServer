require_relative '../mappers_helper'
require_relative 'first_stage_worker'
require_relative 'second_stage_worker'
require_relative 'zero_stage_worker'
require_relative 'third_stage_worker'
require_relative 'fourth_stage_worker'
require_relative 'second_and_half'
require_relative 'third_and_half_worker'


pool_size = ARGV[0].to_i
pool_size ||= 4
redis_host = get_redis_host
redis_cache = RedisCache.new(Redis.new(:host => redis_host, :db => 3))
graph_service_url = get_service_configuration
zero_worker = ZeroStageWorker.pool size: pool_size, args: [redis_cache]
first_worker = FirstStageWorker.pool size: pool_size, args: [redis_cache, graph_service_url]
second_worker = SecondStageWorker.pool size: pool_size, args: [redis_cache, graph_service_url]
fourth_worker = FourthStageWorker.pool size: pool_size, args: [redis_cache]
third_worker = ThirdStageWorker.pool size: pool_size, args: [redis_cache]
third__and_half_worker = ThirdAndHalfStageWorker.pool size: pool_size, args: [redis_cache]
second_and_half_worker = SecondAndHalfStageWorker.pool size: pool_size, args: [redis_cache]


puts "Starting Price Stage"

price_batch_size = 100 * pool_size
Part.joins(:manfr).where(manfr: {name: 'Turbo International'}).
    find_in_batches(batch_size: price_batch_size).map do |groups|
  stage_bulk_body(groups, zero_worker, "Zero ")
end

puts "Starting First Stage "
Part.find_in_batches(batch_size: pool_size).each do |group|
  stage_body(group, first_worker, "First ")
end

puts "Starting Second Stage "
Part.find_in_batches(batch_size: pool_size).each do |group|
  stage_body(group, second_worker, "Second ")
end

puts "Starting Second and Half Stage "
Part.joins(:part_type).where(part_type: {name: 'Turbo'}).
    find_in_batches(batch_size: pool_size).map do |group|
  stage_body(group, second_and_half_worker, "Second and Half  ")
end

puts "Starting Third  Stage "
Part.joins(:part_type).where(part_type: {name: ["Cartridge", "Turbo"]}).
    find_in_batches(batch_size: pool_size).map do |group|
  stage_body(group, third_worker, "Third ")
end

puts "Starting Third and Half  Stage "
Part.find_in_batches(batch_size: pool_size).each do |group|
  stage_body(group, third__and_half_worker, "Third and Half ")
end


puts "Starting Standard Oversize Stage "
Part.joins(:part_type).where(part_type: {
    name: [
        'Journal Bearing', 'Journal Bearing Spacer', 'Piston Ring'
    ]
}).find_in_batches(batch_size: pool_size).each do |group|
  stage_body(group, fourth_worker, "Standard Oversize ")
end
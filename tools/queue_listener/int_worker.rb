require "march_hare"
require_relative  'tools'
ENV['RACK_ENV'] = 'development'
require_relative '../mappers_helper'
require_relative "bom_worker"
require_relative "where_used_worker"


conn = MarchHare.connect
ch = conn.create_channel
q = ch.queue("mq.timms.metadata.staging.bom.changes", :auto_delete => true)
bom_worker = BomWorker.pool
where_used_worker = WhereUsedWorker.pool
tools = Tools.new bom_worker, where_used_worker

q.subscribe(:block => true) do |metadata, payload|
  puts "Received #{payload}"
  tools.run payload
end



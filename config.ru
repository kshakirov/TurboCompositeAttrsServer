require './composite_attr_server.rb'

#\ -w -p 4572
run Rack::URLMap.new({
                         '/' => Public
                     })
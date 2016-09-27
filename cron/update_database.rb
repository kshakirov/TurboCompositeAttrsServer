require 'logger'
require 'rest-client'

def get_statistics filename
  return File.stat(filename).ctime, File.stat(filename).size
end

def save_file data, filename
  file = File.new(filename, 'w')
  file.write data
  file.close
end

logger = Logger.new('/home/ubuntu/TurboCompositeAttrsServer/logs/cron.log')
working_dir = '/home/ubuntu/'
filename = working_dir +  'metadata_prod.sql'
url = 'metadata.turbointernational.com:4568/files/metadata_prod.sql'

Dir.chdir(working_dir)
logger.level =Logger::INFO
logger.info("Starting update")
data = RestClient::Request.execute(:method => :get, :url => url, :timeout => 3600)
save_file(data, filename)
ctime, size = get_statistics(filename)
logger.info("Downloaded File Created [#{ctime.to_s}] Has Size [#{size.to_s}]")
`mysql -h mysql -umetaserver -pgogol metadata < metadata_prod.sql`
logger.info("Database restored from #{filename}, ready to update Redis")
logger.info("Finishing update")


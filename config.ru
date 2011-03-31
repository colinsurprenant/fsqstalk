$: << File.expand_path(File.dirname(__FILE__))

require 'rubygems'

require 'lib/stalker_app'
require 'lib/web_socket_app'
require 'lib/runner'


runner = FsqStalker::Runner.instance
runner.setup('YOUR_FSQ_ACCESS_TOKEN')

runner.stalker.add_venue("173438")  # yul
runner.stalker.add_venue("12238") # sfo  
runner.stalker.add_venue("71375")  # ord
# runner.stalker.add_venue('15166872') # needium HQ
# runner.stalker.add_venue('18231491') # needium watercooler
# runner.stalker.add_venue('128100') # praized hq
# runner.stalker.add_venue('12452877') # cafe la the
# runner.stalker.add_venue('850643') # montreal poutine
# runner.stalker.add_venue("4013658") # maison notman

runner.start

map '/ws' do
  run FsqStalker::WebSocketApp.new(:websocket_debug => false)
end

map '/' do
  run FsqStalker::StalkerApp
end
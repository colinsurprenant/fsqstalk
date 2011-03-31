require 'monitor'
require 'singleton'
require 'lib/stalker'

module FsqStalker
  
  # TODO: this Runner singleton call need to be reworked. 
  # its a quick hack to be able to share the runner between both apps
  class Runner
    include Singleton
    
    attr_reader :listener, :stalker
    
    def setup(access_token)
      @all_events = []
      @all_events.extend(MonitorMixin)
      @new_events = Queue.new
      
      @listener = lambda do |event|
        @all_events.synchronize{@all_events << event}
        @new_events << event
      end
      
      @stalker = FsqStalker::Stalker.new(access_token)
      @stalker.add_listener(listener)
    end
    
    def all_events
      @all_events.synchronize{@all_events.dup}
    end
    
    def new_events
      (size = @new_events.size) > 0 ? (1..size).map{@new_events.pop(non_block = true) rescue nil}.compact : []
    end
    
    def start
      @stalker.start(:block => false)
    end
    
  end
end
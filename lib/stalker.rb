# 4sqmtlhackday
#
# Author::    Colin Surprenant  (mailto:colin.surprenant@gmail.com)

require 'thread'
require 'monitor'
require 'lib/venue'

module FsqStalker

  class Stalker
    
    def initialize(access_token, polls_per_hour = 300)
      Venue.configure(access_token)
      
      @interval = 3600 / polls_per_hour
      @venue_ids = []
      @venue_ids.extend(MonitorMixin) # used in the poller thread
      @listeners = []
      @listeners.extend(MonitorMixin) # used in the listeners thread
      @venue_instances = {} # Venue 
      @history = {}
      @poller_thread = nil
      @listeners_thread = nil
      @events = Queue.new
    end
        
    def start(options = {})
      return if @poller_thread
      @poller_thread = detach_poller_thread
      @listeners_thread = detach_listeners_thread
      options[:block] ? @poller_thread.join : @poller_thread
    end
    
    def stop
      # tbd
    end
    
    def add_venue(venue_id)
      @venue_ids.synchronize do
        @venue_ids << venue_id
        @venue_ids.uniq!
      end
    end
    
    def venues
      @venue_ids.synchronize{@venue_ids.dup}
    end
    
    def add_listener(listener)
      @listeners.synchronize do
        @listeners << listener
      end
    end
    
    private
    
    def venue(venue_id)
      @venue_instances[venue_id] ||= Venue.new(venue_id)
    end
        
    def decorate(venue_id, event)
      event.merge({:created_at => Time.now.to_i, :venue_id => venue_id, :venue => venue(venue_id).details.to_hash, :user_id => event[:user]['id']})
    end
    
    def detach_poller_thread
      Thread.new do
        Thread.current.abort_on_exception = true
        
        loop do
          venues.each do |venue_id|
            current = venue(venue_id).checkins
            previous = (@history[venue_id] || current)
            @history[venue_id] = current
            
            Venue.traffic_events(previous, current).each{|e| @events << decorate(venue_id, e)}
            
            sleep(@interval)
          end          
        end
        
      end
    end
    
    def detach_listeners_thread
      Thread.new do
        Thread.current.abort_on_exception = true
        
        loop do
          event = @events.pop
          listeners = @listeners.synchronize{@listeners.dup}
          listeners.each{|listener| listener.call(event)}
        end
      end
    end

  end
  
end

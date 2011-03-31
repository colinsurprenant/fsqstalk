# 4sqmtlhackday
#
# Author::    Colin Surprenant  (mailto:colin.surprenant@gmail.com)

require 'rack/websocket'
require 'lib/runner'

module FsqStalker

  class WebSocketApp < Rack::WebSocket::Application

    def on_open
      puts("client connected")
      send_data("Stalker Ready")
      
      Runner.instance.stalker.add_listener(listener)
    end
    
    def on_close
      puts("client disconnected")
    end
    
    def on_error(msg)
      puts("error=#{msg}")
    end
    
    private
    
    def summary(event)
      "#{Time.at(event[:created_at]).strftime("%m/%d/%Y %R")} #{event[:type].to_s.upcase} #{event[:venue]['name']} (#{event[:venue_id]}) / #{event[:user]['firstName']} #{event[:user]['lastName']} (#{event[:user_id]})"    
    end
      
    def listener
      @listener ||= lambda do |event|
        send_data(summary(event))        
      end
    end

  end

end
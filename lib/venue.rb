# 4sqmtlhackday
#
# Author::    Colin Surprenant  (mailto:colin.surprenant@gmail.com)

require 'skittles'

module FsqStalker

  class Venue

    attr_reader :details
    
    def initialize(venue_id)
      @venue_id = venue_id
      @details = Skittles.venue(@venue_id)
    end

    def self.configure(access_token)
      Skittles.configure do |config|
        config.access_token  = access_token
      end
    end

    def checkins
      # TODO: add scrolling through results if count > 500 using :offset
      here_now = Skittles.herenow(@venue_id, :limit => 500)
      here_now.items.inject({}){|r, item| r.merge({item.user.id => item.user.to_hash})}
    end

    def self.ins_outs(previous, current)
      stay = previous.keys & current.keys
      outs = previous.keys - stay
      ins = current.keys - previous.keys
      [ins, outs]
    end

    def self.diff_checkins(previous, current)
      ins, outs = ins_outs(previous, current)
      (outs + ins).empty? ? {} : {
        :outs => outs.inject({}){|r, k| r.merge({k => previous[k]})},
        :ins => ins.inject({}){|r, k| r.merge({k => current[k]})},
      }
    end

    def self.traffic_events(previous, current)      
      ins, outs = ins_outs(previous, current)
      outs.map{|k| {:type => :out, :user => previous[k]}} + ins.map{|k| {:type => :in, :user => current[k]}}
    end

  end

end
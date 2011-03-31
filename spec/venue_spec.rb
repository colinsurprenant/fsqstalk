# 4sqmtlhackday
#
# Author::    Colin Surprenant  (mailto:colin.surprenant@gmail.com)

require 'spec_helper'
require 'lib/venue'

module FsqStalker

  describe Venue do
    
    before(:all) do
      @a = {:a => 1}
      @b = {:b => 2}
      @c = {:c => 3}
      @d = {:d => 4}
      @ab = @a.merge(@b)
      @cd = @c.merge(@d)
      @abc = @ab.merge(@c)
      @abcd = @abc.merge(@d)
    end

    it "should diff_checkins" do
      Venue.diff_checkins({}, {}).should == {}
      Venue.diff_checkins(@ab, @ab).should == {}
      Venue.diff_checkins(@ab, @a).should == {:outs => @b, :ins => {}}
      Venue.diff_checkins(@ab, {}).should == {:outs => @ab, :ins => {}}
      
      Venue.diff_checkins(@ab, @abc).should == {:outs => {}, :ins => @c}
      Venue.diff_checkins(@ab, @abcd).should == {:outs => {}, :ins => @cd}

      Venue.diff_checkins(@ab, @cd).should == {:outs => @ab, :ins => @cd}
      Venue.diff_checkins({}, @cd).should == {:outs => {}, :ins => @cd}
    end

    it "should ins_out" do  
      Venue.ins_outs({}, {}).should == [[], []]
      Venue.ins_outs(@ab, @ab).should == [[], []]
      Venue.ins_outs(@ab, @a).should == [[],[:b]]
      Venue.ins_outs(@ab, {}).should == [[], [:a, :b]]      
      Venue.ins_outs(@ab, @abc).should == [[:c], []]
      Venue.ins_outs(@ab, @abcd).should == [[:c, :d], []]
      Venue.ins_outs(@ab, @cd).should == [[:c, :d], [:a, :b]]
      Venue.ins_outs({}, @cd).should == [[:c, :d], []]
    end

    it "should traffic_events" do
      Venue.traffic_events({}, {}).should == []
      Venue.traffic_events(@ab, @ab).should == []
      Venue.traffic_events(@ab, @a).should == [{:type => :out, :user => @b[:b]}]
      Venue.traffic_events(@ab, {}).should == [{:type => :out, :user => @a[:a]}, {:type => :out, :user => @b[:b]}]      
      Venue.traffic_events(@ab, @abc).should == [{:type => :in, :user => @c[:c]}]
      Venue.traffic_events(@ab, @abcd).should == [{:type => :in, :user => @c[:c]}, {:type => :in, :user => @d[:d]}]
      Venue.traffic_events(@ab, @cd).should == [{:type => :out, :user => @a[:a]}, {:type => :out, :user => @b[:b]}, {:type => :in, :user => @c[:c]}, {:type => :in, :user => @d[:d]}]
      Venue.traffic_events({}, @cd).should == [{:type => :in, :user => @c[:c]}, {:type => :in, :user => @d[:d]}]
    end

  end
  
end

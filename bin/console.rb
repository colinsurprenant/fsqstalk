# 4sqmtlhackday
#
# Author::    Colin Surprenant  (mailto:colin.surprenant@gmail.com)

$: << File.expand_path(File.dirname(__FILE__)) + '/../'

require 'rubygems'
require 'lib/stalker'

listener = lambda do |event|
  puts("#{Time.now.strftime("%m/%d/%Y %R")} #{event[:type].to_s.upcase} #{event[:venue]['name']} (#{event[:venue_id]}) / #{event[:user]['firstName']} #{event[:user]['lastName']} (#{event[:user_id]})")
end

begin
  stalker = FsqStalker::Stalker.new('YOUR_FSQ_ACCESS_TOKEN')
  # stalker.add_venue("4013658") # maison notman
  # stalker.add_venue("599266")  # le plateau mont-royal
  # stalker.add_venue("128530") # foursquare

  stalker.add_venue("173438")  # yul
  stalker.add_venue("12238") # sfo  
  stalker.add_venue("71375")  # ord

  # stalker.add_venue('15166872') # needium HQ
  # stalker.add_venue('18231491') # needium watercooler
  # stalker.add_venue('128100') # praized hq
  # stalker.add_venue('12452877') # cafe la the
  # stalker.add_venue('850643') # montreal poutine
  # stalker.add_venue("4013658") # maison notman
  
  stalker.add_listener(listener)

  puts("starting stalker on venues #{stalker.venues}")
  stalker.start(:block => true)
rescue Skittles::Error => e
  puts "Skittles::Error type=#{e.type}, status code=#{e.code}, details=#{e.detail}"
end
  
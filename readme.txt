Foursquare Stalker
Created on the Montreal Foursquare hack day at the Notman House
March 24, 211
Colin Surprenant, colin.surprenant@gmail.com - Praized Media / Needium Lead Platform Architect

Developed using Ruby 1.9.2

This project was initially created at the Foursquare hack day at the Notman House in Montreal 
to create a Foursquare Venue stalking engine. I wanted to be able to see in "realtime" the checkins
at a particular venue. The Venue and Stalker objects provides this functionality.
The Venue object interfaces with a Foursquare venue and the Stalker object is the engine which periodically
polls Foursquare and generates checkin/checkout events. 

An extra challenge was to add a web layer on top of the stalker engine with support for:
- basic html page listing all events
- json endpoint returning new events since the last poll
- websocket endpoint for realtime event push to the browser

This was achieved using mix of Sinatra, Rack, Thin, WebSocket-Rack and EventMachine.

Usage:

- first you need to get a Foursquare access token and insert it in the console.rb and/or config.ru files.
see http://developer.foursquare.com/docs/oauth.html

- for a quick try of the stalker engine use the console. Edit the venue list to stalk inside console.rb and run: 

$ ruby bin/console

- to start the web app, run:

$ thin-websocket start 

- the web app exposes the following endpoint:
  - http://localhost:3000/events
  - http://localhost:3000/events.json
  - http://localhost:3000/wsclient.html

Limitations:

- Foursquare limits the number of requests to their api at 500 per hour. The maximum
number of requests per hour the Stalker object will do is configurable and defaults to 300. 
This means that by default the Stalker engine will not do more than one poll per 12 seconds.
Depending on the number of venues you are stalking, it will take
[number of venues] x [polling interval] to run a full refresh cycle for all venues. 
This obviously does not scale to a very large number of venues. If you want to keep 
the "realtime" latency under 1 minute, you will have to stalk a maximum of 5 venues using
the default rate limit.

Disclaimer:

- I did not put ANY time on the display design. It is really bare bone and raw. 


Until I bundle the required gems, here's the current gem list dump:

addressable (2.2.4)
bundler (1.0.10)
daemons (1.1.2)
diff-lcs (1.1.2)
eventmachine (0.12.10)
faraday (0.5.7)
haml (3.0.25)
hashie (1.0.0)
json (1.5.1)
multi_json (0.0.5)
multipart-post (1.1.0)
oauth2 (0.1.1)
rack (1.2.2)
rack-contrib (1.1.0)
rake (0.8.7)
rspec (2.5.0)
rspec-core (2.5.1)
rspec-expectations (2.5.0)
rspec-mocks (2.5.0)
rubygems-update (1.6.2)
sinatra (1.2.1)
skittles (0.3.1)
thin (1.2.11)
tilt (1.2.2)
websocket-rack (0.1.4)
yajl-ruby (0.8.2)

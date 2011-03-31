# 4sqmtlhackday
#
# Author::    Colin Surprenant  (mailto:colin.surprenant@gmail.com)

require 'sinatra/base'
require 'rack/contrib/jsonp'
require 'haml'
require 'json'
require 'lib/runner'

module FsqStalker
  
  class StalkerApp < Sinatra::Base
          
    configure do
      set :root, File.dirname(__FILE__) + '/../'
      set :static, true
    end

    template :layout do
      "%html\n  =yield\n"
    end

    use Rack::JSONP
    
    get '/events' do
      @events = Runner.instance.all_events
      haml :index, :format => :html4
    end
    
    get '/events.json' do
      content_type :json
      Runner.instance.new_events.to_json
    end
          
  end #class WebController
  
end #module Praized


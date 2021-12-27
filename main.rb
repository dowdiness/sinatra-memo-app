require 'sinatra'
require 'sinatra/reloader'

get '/' do
  erb :index
end

get '/hello/*' do |name|
  "hello #{name}. how are you?"
end

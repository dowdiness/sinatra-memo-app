require 'sinatra'
require 'sinatra/reloader'
require './db'

get '/' do
  @memo_data = memo_decode 'path'
  erb :index, locals: { memo: @memo_data }
end

get '/new' do
  erb :new
end

get '/edit' do
  erb :edit
end

get '/show' do
  erb :show
end

get '/hello/*' do |name|
  "hello #{name}. how are you?"
end

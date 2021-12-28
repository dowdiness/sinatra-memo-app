require 'sinatra'
require 'sinatra/reloader'
require './db'

db = DB.new

get '/' do
  @data = db.data
  erb :index
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

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

delete '/reset' do
  db.reset
  @data = db.data
  redirect '/'
end

get '/edit' do
  erb :edit
end

# show
get '/*' do |title|
  @memo = db.get_by_title title
  erb :show
end

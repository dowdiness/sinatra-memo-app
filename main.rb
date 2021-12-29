require 'sinatra'
require 'sinatra/reloader'
require './db'

db = DB.new

get '/' do
  @message = session.delete(:message)
  @data = db.data
  erb :index
end

get '/new' do
  erb :new
end

post '/new' do
  db.add_memo({ "title" => params[:title], "content" => params[:content] })
  session[:message] = "#{params[:title]}の保存に成功しました"
  redirect '/'
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

require 'sinatra'
require 'sinatra/reloader'
require './db'

enable :sessions

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

get '/edit/*' do |title|
  @memo = db.get_by_title title
  erb :edit
end

get '/reset' do
  erb :reset
end

delete '/reset' do
  db.reset
  @data = db.data
  session[:message] = "メモを全て削除しました"
  redirect '/'
end

# show
get '/*' do |title|
  @memo = db.get_by_title title
  erb :show
end

put '/*' do |title|
  db.update_by_title(title, { "title" => params[:title], "content" => params[:content] })
  session[:message] = "#{title}を#{params[:title]}へ更新しました"
  redirect '/'
end

delete '/*' do |title|
  session[:message] = if db.delete_by_title(title).nil?
    "メモが見つかりませんでした"
  else
    "#{title}を削除しました"
  end
  redirect '/'
end

not_found do
  erb :not_found
end

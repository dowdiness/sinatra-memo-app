require 'sinatra'
require 'sinatra/reloader'
require './extensions/html_escape'
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
  title = h(params[:title])
  content = h(params[:content])
  db.add_memo({ "title" => title, "content" => content })
  session[:message] = "#{title}の保存に成功しました"
  redirect '/'
end

get '/edit/*' do |title|
  title = h(title)
  @memo = db.get_by_title h(title)
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
  title = h(title)
  @memo = db.get_by_title h(title)
  erb :show
end

put '/*' do |title|
  title = h(title)
  new_title = h(params[:title])
  new_content = h(params[:content])
  db.update_by_title(title, { "title" => new_title, "content" => new_content })
  session[:message] = "#{title}を#{new_title}へ更新しました"
  redirect '/'
end

delete '/*' do |title|
  title = h(title)
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

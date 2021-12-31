# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require './extensions/html_escape'
require './extensions/validation'
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
  begin
    validates do
      params do
        required(:title).filled(:string)
        required(:content).filled(:string)
      end
    end
  rescue Sinatra::Validation::InvalidParameterError => e
    # Arrayにして処理したい
    session[:message] = e.result.messages.first
    redirect '/'
  end
  title = h(params[:title])
  content = h(params[:content])
  db.add_memo({ 'title' => title, 'content' => content })
  session[:message] = "#{title}の保存に成功しました"
  redirect '/'
end

get '/:title/edit' do
  title = h(params[:title])
  @memo = db.get_by_title title
  erb :edit
end

get '/reset' do
  erb :reset
end

delete '/reset' do
  db.reset
  @data = db.data
  session[:message] = 'メモを全て削除しました'
  redirect '/'
end

# show
get '/:title' do
  title = h(params[:title])
  @memo = db.get_by_title title
  if @memo.nil?
    halt 404
  else
    erb :show
  end
end

put '/:old_title' do
  begin
    validates do
      params do
        required(:old_title).filled(:string)
        required(:new_title).filled(:string)
        required(:content).filled(:string)
      end
    end
  rescue Sinatra::Validation::InvalidParameterError => e
    # Arrayにして処理したい
    session[:message] = e.result.messages.first
    redirect '/'
  end
  old_title = h(params[:old_title])
  new_title = h(params[:new_title])
  new_content = h(params[:content])
  db.update_by_title(old_title, { 'title' => new_title, 'content' => new_content })
  session[:message] = "#{old_title}を#{new_title}へ更新しました"
  redirect '/'
end

delete '/:title' do |title|
  title = h(title)
  session[:message] = if db.delete_by_title(title).nil?
                        'メモが見つかりませんでした'
                      else
                        "#{title}を削除しました"
                      end
  redirect '/'
end

not_found do
  erb :not_found
end

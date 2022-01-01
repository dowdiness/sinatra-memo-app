# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
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
  db.add_memo({ 'id' => SecureRandom.uuid, 'title' => title, 'content' => content })
  session[:message] = "#{title}の保存に成功しました"
  redirect '/'
end

get '/:id/edit' do
  id = h(params[:id])
  @memo = db.find id
  if @memo.nil?
    halt 404
  else
    erb :edit
  end
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
get '/:id' do
  id = h(params[:id])
  @memo = db.find id
  if @memo.nil?
    halt 404
  else
    erb :show
  end
end

put '/:id' do
  begin
    validates do
      params do
        required(:id).value(:filled?, :uuid_v4?)
        required(:new_title).filled(:string)
        required(:content).filled(:string)
      end
    end
  rescue Sinatra::Validation::InvalidParameterError => e
    # Arrayにして処理したい
    session[:message] = e.result.messages.first
    redirect '/'
  end
  id = h(params[:id])
  new_title = h(params[:new_title])
  new_content = h(params[:content])
  session[:message] = if db.update(id, { 'id' => id, 'title' => new_title, 'content' => new_content }).nil?
                        'メモの更新に失敗しました'
                      else
                        "#{id}を更新しました"
                      end
  redirect '/'
end

delete '/:id' do
  id = h(params[:id])

  session[:message] = if db.delete(id).nil?
                        'メモが見つかりませんでした'
                      else
                        "#{id}を削除しました"
                      end
  redirect '/'
end

not_found do
  erb :not_found
end

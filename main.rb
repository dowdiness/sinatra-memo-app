# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'securerandom'
require './extensions/validation'
require './extensions/html_escape'
require './db'
require 'cgi'

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

post '/' do
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
  title = params[:title]
  content = params[:content]
  is_sccuess = db.add_memo({ id: SecureRandom.uuid, title: title, content: content })
  if is_sccuess == false
    session[:message] = "#{CGI.escapeHTML(title)}の保存に失敗しました"
  else
    session[:message] = "#{CGI.escapeHTML(title)}の保存に成功しました"
  end
  redirect '/'
end

get '/:id/edit' do
  id = params[:id]
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
  is_success = db.reset
  if is_success
    @data = db.data
    session[:message] = 'メモを全て削除しました'
  else
    session[:message] = 'メモのリセットに失敗しました'
  end
  redirect '/'
end

# show
get '/:id' do
  id = params[:id]
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
  id = params[:id]
  new_title = params[:new_title]
  new_content = params[:content]
  session[:message] = if db.update(id, { id: id, title: new_title, content: new_content }) == false
                        'メモの更新に失敗しました'
                      else
                        "#{CGI.escapeHTML(new_title)}を更新しました"
                      end
  redirect '/'
end

delete '/:id' do
  id = params[:id]

  session[:message] = if db.delete(id) == false
                        'メモが見つかりませんでした'
                      else
                        'メモを削除しました'
                      end
  redirect '/'
end

not_found do
  erb :not_found
end

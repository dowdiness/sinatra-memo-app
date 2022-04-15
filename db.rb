# frozen_string_literal: true

require 'json'
require 'pg'

class DB
  attr_reader :data

  def initialize(dbname = 'sinatra_memo')
    @data = { memos: [] }
    begin
      @conn = PG.connect( dbname: dbname )
      # Install UUID extension
      @conn.exec(<<~SQL)
        CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
      SQL
      # Create memo table
      @conn.exec(<<~SQL)
        CREATE TABLE IF NOT EXISTS memos (
          id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
          title    varchar(40) NOT NULL,
          content  text NOT NULL
        )
      SQL
      # Query memos
      @conn.exec( "SELECT * FROM memos;" ) do |result|
        result.each do |row|
          @data[:memos].push symbolize_keys(row)
        end
      end
    rescue => e
      p e
    end
  end

  def add_memo(memo)
    is_added = false
    is_added = add_sql(memo[:id], memo[:title], memo[:content])
    @data[:memos] << memo if is_added == true
    is_added
  end

  def find(id)
    @data[:memos].each do |memo|
      return memo if memo[:id] == id
    end
    nil
  end

  # TODO It must to be transaction
  def update(id, new_memo)
    is_updated = false
    @data[:memos].map! do |memo|
      if memo[:id] == id
        is_updated = true
        new_memo
      else
        memo
      end
    end
    return false unless is_updated
    update_sql(id, new_memo[:title], new_memo[:content])
  end

  # TODO It must to be transaction
  def delete(id)
    is_deleted = @data[:memos].filter! do |memo|
      memo[:id] != id
    end
    unless is_deleted.nil?
      is_deleted = delete_sql id
    end
    is_deleted
  end

  def reset
    begin
      @conn.exec("DELETE FROM memos;")
      @data = { memos: [] }
      true
    rescue => e
      p e
      false
    end
  end

  private

  def symbolize_keys(hash)
    hash.map{|k,v| [k.to_sym, v] }.to_h
  end

  def add_sql(id, title, content)
    begin
      @conn.exec("INSERT INTO memos VALUES(uuid('{' || '#{id}' || '}'), '#{title}', '#{content}');")
      true
    rescue => e
      p e
      false
    end
  end

  def update_sql(id, title, content)
    begin
      @conn.exec("UPDATE memos SET title = '#{title}', content = '#{content}' WHERE id = uuid('{' || '#{id}' || '}');")
      true
    rescue => e
      p e
      false
    end
  end

  def delete_sql id
    begin
      @conn.exec("DELETE FROM memos WHERE id = uuid('{' || '#{id}' || '}');")
      true
    rescue => e
      p e
      false
    end
  end
end

# frozen_string_literal: true

require 'json'

class DB
  attr_reader :data

  def initialize(path = './data/data.json')
    @data_path = path unless path.nil?
    if File.exist? @data_path
      File.open(path) do |file|
        @data = JSON.parse(file.read)
      end
    else
      File.open(path, 'w') do |file|
        @data = { 'memos' => [] }
        JSON.dump(@data, file)
      end
    end
  end

  def add_memo(memo)
    @data['memos'] << memo
    File.open(@data_path, 'w') do |file|
      JSON.dump(@data, file)
    end
  end

  def find_by(id)
    @data['memos'].each do |memo|
      return memo if memo['id'] == id
    end
    nil
  end

  def update_by(id, new_memo)
    is_updated = false
    @data['memos'].map! do |memo|
      if memo['id'] == id
        is_updated = true
        new_memo
      else
        memo
      end
    end
    unless is_updated
      nil
    else
      File.open(@data_path, 'w') do |file|
        JSON.dump(@data, file)
      end
      @data
    end
  end

  def delete_by(id)
    is_success = @data['memos'].filter! do |memo|
      memo['id'] != id
    end
    unless is_success.nil?
      File.open(@data_path, 'w') do |file|
        JSON.dump(@data, file)
      end
    end
    is_success
  end

  def reset
    File.open(@data_path, 'w') do |file|
      @data = { 'memos' => [] }
      JSON.dump(@data, file)
    end
  end
end

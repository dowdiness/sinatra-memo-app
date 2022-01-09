# frozen_string_literal: true

require 'json'
require 'erb'

class DB
  def data
    { memos: @_data[:memos].map { |memo| escape memo }}
  end

  def escape(data)
    {
      id: data[:id],
      title: ERB::Util.html_escape(data[:title]),
      content: ERB::Util.html_escape(data[:content])
    }
  end

  def initialize(path = '.data.json')
    @data_path = path unless path.nil?
    if File.exist? @data_path
      File.open(path) do |file|
        @_data = JSON.parse(file.read, symbolize_names: true)
        p @_data
      end
    else
      File.open(path, 'w') do |file|
        @_data = { memos: [] }
        JSON.dump(@data, file)
      end
    end
  end

  def add_memo(memo)
    @_data[:memos] << memo
    File.open(@data_path, 'w') do |file|
      JSON.dump(@_data, file)
    end
  end

  def find(id)
    @_data[:memos].each do |memo|
      return escape(memo) if memo[:id] == id
    end
    nil
  end

  def update(id, new_memo)
    is_updated = false
    @_data[:memos].map! do |memo|
      if memo[:id] == id
        is_updated = true
        new_memo
      else
        memo
      end
    end
    return nil unless is_updated

    File.open(@data_path, 'w') do |file|
      JSON.dump(@_data, file)
    end
    escape(@_data)
  end

  def delete(id)
    is_success = @_data[:memos].filter! do |memo|
      memo[:id] != id
    end
    unless is_success.nil?
      File.open(@data_path, 'w') do |file|
        JSON.dump(@_data, file)
      end
    end
    is_success
  end

  def reset
    File.open(@data_path, 'w') do |file|
      @_data = { memos: [] }
      JSON.dump(@_data, file)
    end
  end
end

require "json"

class DB
  attr_reader :data

  def initialize path = "./data/data.json"
    @@data_path = path unless path.nil?
    unless File.exist? @@data_path
      File.open(path, 'w') do |file|
        @data = JSON.load(file)
      end
    end
    @data ||= json_decode @@data_path
  end

  def json_decode path
    data = {}
    File.open(path) do |file|
      data = JSON.load(file)
    end
    p data[:memos]
    data
  end

  def json_encode data
    @data = data
    File.open(@@data_path, 'w') do |file|
      JSON.dump(@data, file)
    end
  end

  def get_by_title title
    @data["memos"].each do |memo|
      return memo if memo["title"] == title
    end
    raise "#{title}というタイトルのメモは存在しません"
  end

  def add_memo memo
    @data["memos"] << memo
    File.open(@@data_path, 'w') do |file|
      JSON.dump(@data, file)
    end
  end

  def reset
    File.open(@@data_path, 'w') do |file|
      @data = { "memos" => [] }
      JSON.dump(@data, file)
    end
  end

end

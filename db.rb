require "json"

class DB
  attr_reader :data

  def initialize path = "./data/data.json"
    @@data_path = path unless path.nil?
    json_decode @@data_path
  end

  def json_decode path
    File.open(path) do |file|
      @data = JSON.parse(file)
    end
    @data
  end

  def json_encode data
    File.open(@@data_path, 'w') do |file|
      @data = JSON.dump(data, file)
    end
  end

  def get_by_title title
    @data["memos"].each do |memo|
      return memo if memo["title"] == title
    end
    raise NameError, "#{title}というタイトルのメモは存在しません"
  end

end

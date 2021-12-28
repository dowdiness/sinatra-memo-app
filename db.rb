require "json"

class DB
  attr_reader :data

  def initialize path = "./data/data.json"
    @@data_path = path if !path.nil?
    json_decode path
  end

  def json_decode path
    File.open(path) do |file|
      @data = JSON.load(file)
    end
    @data
  end

  def json_encode data
    File.open(@@data_path, 'w') do |file|
      @data = JSON.dump(data, file)
    end

  end
end

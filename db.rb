require "json"

class DB
  attr_reader :data

  def initialize path = "./data/data.json"
    @@data_path = path unless path.nil?
    if File.exist? @@data_path
      File.open(path) do |file|
        @data = JSON.load(file)
      end
    else
      File.open(path, 'w') do |file|
        @data = { "memos" => [] }
        JSON.dump(@data, file)
      end
    end
  end

  def add_memo memo
    @data["memos"] << memo
    File.open(@@data_path, 'w') do |file|
      JSON.dump(@data, file)
    end
  end

  def get_by_title title
    @data["memos"].each do |memo|
      return memo if memo["title"] == title
    end
    return nil
  end

  #todo エラー処理
  def update_by_title(title, new_memo)
    @data["memos"].map! do |memo|
      if memo["title"] == title
        new_memo
      else
        memo
      end
    end
    File.open(@@data_path, 'w') do |file|
      JSON.dump(@data, file)
    end
  end

  def delete_by_title title
    is_success = @data["memos"].filter! do |memo|
      memo["title"] != title
    end
    File.open(@@data_path, 'w') do |file|
      JSON.dump(@data, file)
    end
    is_success
  end

  def reset
    File.open(@@data_path, 'w') do |file|
      @data = { "memos" => [] }
      JSON.dump(@data, file)
    end
  end

end

require "json"

require_relative "helper"
require_relative "data"

class Store < Data
  attr_reader :data

  def initialize
    @@absolute_path_handler = -> () {absolute_path("../../share/store.json")}
    @@get_data_handler = -> (value) { @data_store[value] }

    @data = @@get_data_handler
    super
  end

  def set_data data
    json_obj = get_data
    data_mutate = -> (symbol) do
      if data[symbol]
        json_obj[symbol.to_s] = data[symbol]
        puts "#{symbol.to_s}: #{data[symbol]}"
      end
    end

    data.each do |k,_|
      data_mutate.call(k)
    end

    write_data json_obj, @@absolute_path_handler.call
    Process.kill("USR1", pid_term().to_i)
  end

  def to_s
    open_data @@absolute_path_handler.call
  end

  def update
    set_data_store()
  end

  private
  def open_data path
    json_obj = nil
    if File.exist? path
      File.open path do |file|
        begin
          json_obj = file.read
        end
      end
    end
    return json_obj
  end

  def write_data data, path
    json_obj = nil
    begin
      f = File.new path, "w+"
        json = JSON.pretty_generate data
        f.write json
      f.close
    end
    return json_obj
  end

  def get_data
    data = open_data @@absolute_path_handler.call
    if data
      data = JSON.parse data
    end
    return data
  end

  def set_data_store
    data = get_data
    data.each do |k,v|
      @data_store[k] = v
    end
  end
end
class Data
  STORE = Struct.new(:in, :out, :command)

  def initialize
    @data_store = STORE.new
    set_data_store()
  end

  def set_data_store
    raise "The 'set data store' is abstract method. Please implement in inheritance class."
  end
end

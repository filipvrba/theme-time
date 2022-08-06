Signal.trap("INT") do
  puts "Exiting the app"
  exit
end

def sig_update_store(&callback)
  Signal.trap("USR1") do
    callback.call
  end
end

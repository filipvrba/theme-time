require_relative "store"
require_relative "arguments"
require_relative "signals"

require "time"

def get_hour
  Time.now.hour
end

def running?
  pid = Process.pid
  pid_term = %x(pgrep -f theme-time)

  if pid != pid_term.to_i
    puts "This #{pid_term.to_i} pid still running in process."
    return true
  end

  return false
end

def main
  @active_cycle_bit = 0
  @is_one_activate_cycle = -> (bit) {@active_cycle_bit & bit != 0}

  loop(1)
end

def theme_active(style)
  unless @options[:is_dev]
    command = @store.data.call("command").to_s.sub('*', style)
    %x(#{command})
  end

  unless @options[:is_fork]
    puts "Theme: #{style}"
  end
end

def loop time_cycle
  while true
    # True  - light
    # False - dark
    # is_active_time_zone = get_hour < @store.data.call("in").to_i ||
    #                       get_hour >= @store.data.call("out").to_i
    is_night = get_hour < @store.data.call("in").to_i ||
               get_hour >= @store.data.call("out").to_i
    is_day   = get_hour >= @store.data.call("in").to_i &&
               get_hour < @store.data.call("out").to_i
    
    if is_day              # 1 bit flag
      unless @is_one_activate_cycle.(1)
        @active_cycle_bit |= 1

        if @is_one_activate_cycle.(2)
          @active_cycle_bit &= ~2
        end
        theme_active("light")
      end
    elsif is_night                                    # 2 bit flag
      unless @is_one_activate_cycle.(2)
        @active_cycle_bit |= 2
        if @is_one_activate_cycle.(1)
          @active_cycle_bit &= ~1
        end
        theme_active("dark")
      end
    end
    sleep time_cycle
  end
end

@store = Store.new
if @options[:is_store]
  puts @store.to_s
  exit
end

if @options[:in] or @options[:out] or
   @options[:command]

  data = {in: @options[:in], out: @options[:out],
          command: @options[:command]}
  @store.set_data data
else
  if running?
    exit
  end

  if @options[:is_fork]
    pid = fork do
      main()
    end
    puts pid
  else
    main()
  end
end
require_relative "store"
require_relative "arguments"
require_relative "signals"

require "time"

def get_hour
  Time.now.hour
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

  puts "Theme: #{style}"
end

def loop time_cycle
  while true
    # True  - light
    # False - dark
    is_active_time_zone = get_hour >= @store.data.call("in").to_i &&
                          get_hour >= @store.data.call("out").to_i
    
    unless is_active_time_zone              # 1 bit flag
      unless @is_one_activate_cycle.(1)
        @active_cycle_bit |= 1

        if @is_one_activate_cycle.(2)
          @active_cycle_bit &= ~2
        end
        theme_active("light")
      end
    else                                    # 2 bit flag
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
  main()
end
require_relative "helper"

require absolute_path("../../lib/index")

@options = {
  is_dev: false,
  is_store: false,
  in: nil,
  out: nil,
  command: nil,
}

OptionParser.parse do |parser|
  parser.banner( "This app is for change themes in an time intervals.\n\nOptions:" )
  parser.on( "-h", "--help", "Show help" ) do
      puts parser
      exit
  end
  parser.on( "-d", "--dev", "Develop mode" ) do
    @options[:is_dev] = true
  end
  parser.on( "-gs", "--get-store", "Show a store via formatted json." ) do
    @options[:is_store] = true
  end
  parser.on( "-si NUMBER", "--set-in NUMBER", "Set a 'in' value." ) do |number|
    @options[:in] = number
  end
  parser.on( "-so NUMBER", "--set-out NUMBER", "Set a 'out' value." ) do |number|
    @options[:out] = number
  end
  parser.on( "-sc COMMAND", "--set-com COMMAND", "Set a 'command' value." ) do |command|
    @options[:command] = command
  end
end
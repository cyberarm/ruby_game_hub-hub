USE_COLOR = true

require "openssl"
require "socket"
begin
  require "colorize"
rescue LoadError
  USE_COLOR = false
end

require_relative "lib/all"

Thread.abort_on_exception = true # Debugging threads that don't crash is hard.

begin
  RubyGameHub::Hub.new(host: "0.0.0.0", port: 56788).chatterbox.start
rescue Interrupt
  RubyGameHub::Hub.instance.chatterbox.stop
  # Eat error
rescue SystemExit
  RubyGameHub::Hub.instance.chatterbox.stop
  # Return error
  raise
end

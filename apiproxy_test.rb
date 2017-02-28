require "socket"
require "openssl"

@socket = TCPSocket.new("localhost", 56788)

loop do
  @socket.puts "HELLO"
  puts @socket.gets
end

@socket.close

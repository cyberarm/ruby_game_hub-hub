def logger(*args); p args; end

require "socket"
require "openssl"
require "base64"
require "uri"
require "zlib"

require_relative "lib/chatterbox/authentication"
require_relative "lib/chatterbox/proto"

@socket = TCPSocket.new("localhost", 56788)
@keypair= RubyGameHub::ChatterBox::Authentication.new

include RubyGameHub::ChatterBox::Proto

def compress_for_transport(string)
  Base64.strict_encode64(string)
end

def uncompress_from_transport(string)
  Base64.strict_decode64(string)
end

@socket.puts API_GREETING
p @socket.gets.chomp
@socket.puts "#{API_PUBLIC_KEY}:#{compress_for_transport(@keypair.public_key.to_der)}"
hub_key = @socket.gets.chomp
p hub_key
if hub_key.start_with?("FAULT")
  puts "Something went wrong!"
else
  hub_key = hub_key.split(":")
end
@remote_publickey = OpenSSL::PKey::RSA.new uncompress_from_transport(hub_key.last)
p @remote_publickey.public?
enc = (@remote_publickey.public_encrypt("?"))
encoded = compress_for_transport(enc)
p enc
p uncompress_from_transport(encoded)
@socket.puts "VERIFY:#{encoded}"
p @socket.gets.chomp
@socket.puts API_DISCONNECT
puts  "Complete"

@socket.close

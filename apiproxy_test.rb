def logger(*args); p args; end

require "socket"
require "openssl"
require "base64"
require "zlib"
require_relative "lib/chatterbox/authentication"
require_relative "lib/chatterbox/proto"

@socket = TCPSocket.new("localhost", 56788)
@keypair= RubyGameHub::ChatterBox::Authentication.new

include RubyGameHub::ChatterBox::Proto


def compress_for_transport(string)
  c = Zlib::Deflate.deflate(string)
  s = Base64.strict_encode64(c)
  return s
end

def uncompress_from_transport(string)
  s = Base64.strict_decode64(string)
  c = Zlib::Inflate.inflate(s)
  return c
end

@socket.puts API_GREETING
p @socket.gets.chomp
@socket.puts "#{API_PUBLIC_KEY}:#{compress_for_transport(@keypair.public_key.to_pem)}"
hub_key = @socket.gets.chomp
p hub_key
if hub_key.start_with?("FAULT")
  puts "Something went wrong!"
else
  hub_key = hub_key.split(":")
end
@remote_publickey = OpenSSL::PKey::RSA.new uncompress_from_transport(hub_key.last)
p @remote_publickey.public?
@socket.puts API_DISCONNECT
puts  "Complete"

@socket.close

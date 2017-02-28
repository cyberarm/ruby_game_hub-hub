module RubyGameHub
  class Server
    TAG = "Server"
    attr_reader :name, :hostname, :port, :state, :ping, :region, :clients, :uptime
  end
end

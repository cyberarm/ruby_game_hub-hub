module RubyGameHub

  # Proxy for communicating with website API
  class ChatterBox
    TAG = "ChatterBox"
    TAG_COLOR = :green

    attr_reader :host, :port, :server

    def initialize(host, port)
      @host = host
      @port = port

      @run_server = true
      @server_running = false

      @server = TCPServer.new(@host, @port)
    end

    def log(string, level = "debug")
      logger(TAG, string, TAG_COLOR, level)
    end

    def start
      @server_running = true
      log("Starting server at #{@host} on #{@port}.")
      while(@run_server) do
        Thread.start(@server.accept) do |client|
          client.puts "HI"

          log("client address: #{client.remote_address.ip_address}")
          log("Client data: #{client.gets}")
          # client.close
        end
      end

      @server_running = false
    end

    def stop
      @run_server = false
      log("Stopping server...")
    end
  end
end

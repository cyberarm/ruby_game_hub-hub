module RubyGameHub

  # Proxy for communicating with website API
  class ChatterBox
    TAG = "ChatterBox"
    TAG_COLOR = :green

    attr_reader :host, :port, :server, :clients, :authentication

    def initialize(host, port)
      @host = host
      @port = port

      @loop = nil

      @clients = {}
      @authentication = Authentication.new
    end

    def log(string, level = "debug")
      logger(TAG, string, TAG_COLOR, level)
    end

    def start
      log("Starting server at #{@host} on #{@port}.")
      EventMachine.run do |ev|
        EventMachine.start_server(@host, @port, ChatterBox::Server)
        @loop = ev
      end
    end

    def reject(reason, socket)
      socket.puts(reason)
      socket.close
    end

    def stop
      log("Stopping server...")
      if EventMachine.reactor_running?
        EventMachine.stop
      end
    end
  end
end

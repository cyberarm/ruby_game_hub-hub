module RubyGameHub
  class Hub
    TAG = "Hub"
    TAG_COLOR = :blue

    attr_reader :options, :chatterbox, :lobbies, :players, :servers

    def self.instance; @instance; end
    def self.instance=(_instance); @instance = _instance; end

    def initialize(options = {})
      Hub.instance=self

      @lobbies = []
      @players = []
      @servers = []

      @chatterbox = ChatterBox.new(options[:host], options[:port])
    end

    def log(string, level = "debug")
      logger(TAG, string, TAG_COLOR, level)
    end

    def add(type, object)
      case type
      when :lobby
        if object.is_a?(Lobby) then @lobbies.push(object); log(TAG, "Added Lobby."); end
      when :player
        if object.is_a?(Player) then @players.push(object); log(TAG, "Added Player."); end
      when :server
        if object.is_a?(Server) then @servers.push(object); log(TAG, "Added Server."); end
      end
    end

    def remove(type, object)
      case type
      when :lobby
        @lobbies.detect(object).destroy if object.is_a?(Lobby)
      when :player
        @players.detect(object).destroy if object.is_a?(Player)
      when :server
        @servers.detect(object).destroy if object.is_a?(Server)
      end
    end
  end
end

module RubyGameHub
  class ChatterBox
    Client = Struct.new(:hash)
    module Server
      TAG = "SERVER"
      TAG_COLOR = :yellow

      def log(string, level = "debug")
        logger(TAG, string, TAG_COLOR, level)
      end

      def post_init
        @clients = {}
        @authentication = Authentication.new
        log("Server started...")
      end

      def receive_data(data)
        data = data.chomp
        client = nil
        port, ip = Socket.unpack_sockaddr_in(get_peername)

        if @clients[ip]
          if @clients[ip][port]
            client = @clients[ip][port]
          else
            client = @clients[ip][port] = new_client
          end
        else
          @clients[ip] = {}
          client = @clients[ip][port] = new_client
        end

        log("client: "+data)

        if data == Proto::API_GREETING
          client.hash[:is_polite] = true
          send_data "#{Proto::HUB_GREETING}\n"
        elsif data.split(":").first == Proto::API_PUBLIC_KEY && client.hash[:is_polite]
          # yep
          begin
            api_public_key_string = uncompress_from_transport(data.split(":").last)

            client.hash[:public_key] = OpenSSL::PKey::RSA.new(api_public_key_string)
            client.hash[:sent_key] = true

            send_data("#{Proto::HUB_PUBLIC_KEY}:#{compress_for_transport(@authentication.public_key.to_pem)}\n")
          rescue => e
            log_and_send(e)
            close_connection
          end
        else
          log("Got unprocessable data: #{data}", "warn")
        end

        if data != "HELLO" && !client.hash[:is_polite]
          log_and_send("Client is rude.")
          close_connection
        end
      end

      def new_client
        hash = {}
        hash[:connected_at] = Time.now.utc
        hash[:is_polite]    = false
        hash[:sent_key]     = false
        hash[:is_verified]  = false
        hash[:public_key]   = nil
        hash[:auth_token]   = nil

        Client.new(hash)
      end

      def compress_for_transport(string)
        log(string, "fail")
        c = Zlib::Deflate.deflate(string)
        p c
        # s = Base64.encode64(c)
        # p s
        return c
      end

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

      def unbind
        log("Disconnect")
      end
    end
  end
end

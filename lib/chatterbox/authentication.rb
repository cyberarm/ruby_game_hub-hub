module RubyGameHub
  class ChatterBox
    class Authentication
      TAG = "AUTH"
      TAG_COLOR = :blue

      def initialize(public_key_pem = nil, size = 1024)
        # keypair_path = "data/keys"?
        @keypair = nil
        @remote_publickey = nil
        @digest = OpenSSL::Digest::SHA256.new

        log("WARNING: Key size is '#{size}' and may be to small!", "warn") if size < 4096

        if public_key_pem
          log("Using Public Key...")
          @remote_publickey = OpenSSL::PKey::RSA.new(public_key_pem)
        else
          log("Generating KeyPair...")
          @keypair = OpenSSL::PKey::RSA.new(size)
        end

        log("Done.")
      end

      def log(string, level = "debug")
        logger(TAG, string, TAG_COLOR, level)
      end

      def public_key
        @keypair.public_key
      end

      def sign(data)
        @keypair.sign(@digest, data)
      end

      def verify(data)
        @keypair.verify(@digest, sign(data), data)
      end
    end
  end
end

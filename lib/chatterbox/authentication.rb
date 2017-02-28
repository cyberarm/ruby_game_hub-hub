module RubyGameHub
  class ChatterBox
    class Authentication
      def initialize(keypair_path = "data/keys", enabled = true)
        @keypair = OpenSSL::PKey::RSA.new(2048)
        @signature = OpenSSL::Digest::SHA256.new

        @remote_publickey = nil
      end

      def sign(data)
        @keypair.sign(@signature, data)
      end

      def verify(data)
        @remote_publickey.verify(@remote_digest, @signature, data)
      end
    end
  end
end

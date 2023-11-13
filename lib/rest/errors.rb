module  Rest
  module Errors
    class AuthenticationError < StandardError
      attr_reader :code, :data

      def initialize(code = 401, data = {}, msg = "Auth Error")
        super(msg)
        @data = data
        @code = code
      end
    end

    class WalletError < StandardError
      attr_reader :code, :data

      def initialize(code, data = {}, msg = "Transfer Error")
        super(msg)
        @data = data
        @code = code
      end
    end

    class TransactionError < StandardError
      attr_reader :code, :data

      def initialize(code, data = {}, msg = "Transfer Error")
        super(msg)
        @data = data
        @code = code
      end
    end
  end
end


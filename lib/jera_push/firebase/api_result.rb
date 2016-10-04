module JeraPush
  module Firebase
    class ApiResult

      attr_accessor :result

      def initialize(firebase_response)
        @result = firebase_response
      end

      def success?
        result && result.code == 200
      end
    end
  end
end

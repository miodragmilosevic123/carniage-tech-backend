module Error
  class UnauthorizedError < StandardError
    attr_reader :status, :error, :message

    def initialize(message)
      @error = 401
      @status = :unauthorized
      @message = message
    end

    def fetch_json
      Helpers::Render.json(error, message, status)
    end
  end
end
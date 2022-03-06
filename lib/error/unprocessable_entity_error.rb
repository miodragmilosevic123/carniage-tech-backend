module Error
  class UnprocessableEntityError < StandardError
    attr_reader :status, :error, :message

    def initialize(message)
      @error = 422
      @status = :unprocessable_entity
      @message = message
    end

    def fetch_json
      Helpers::Render.json(error, message, status)
    end
  end
end
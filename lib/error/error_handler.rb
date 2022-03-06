module Error
  module ErrorHandler
    def self.included(cl)
      cl.class_eval do
        rescue_from ActiveRecord::RecordNotFound do
          respond(404, :bad_request, 'Record not found')
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
          respond(422, :unprocessable_entity, e)
        end

        rescue_from UnprocessableEntityError do |e|
          respond(e.error, e.status, e.message)
        end
        rescue_from UnauthorizedError do |e|
          respond(e.error, e.status, e.message)
        end
      end
    end

    private

    def respond(_error, _status, _message)
      json = Helpers::Render.json(_error, _status, _message)
      render json: json
    end
  end
end
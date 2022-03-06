module Api
  class AuthsController < ApplicationController
    abstract!

    private

    def authorize_user
      begin
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        decoded = JsonWebToken.decode(header)
        @user = User.find(decoded[:id])
      rescue ActiveRecord::RecordNotFound
        raise Error::UnauthorizedError.new("User don't exist")
      rescue JWT::DecodeError
        raise Error::UnauthorizedError.new('Invalid JWT Token')
      end
    end
  end
end

module Api
  class UsersController < AuthsController
    before_action :authorize_user, except: %i[create login]
    before_action :encrypt_password, only: :create

    def create
      @user = User.create!(user_params)
      @token = JsonWebToken.encode(id: @user.id) if @user
      render :show, status: :created
    end

    def login
      @user = User.find_by(username: params[:username])

      if @user && @user.password_digest == User.encrypt_password(params[:password_digest])
        @token = JsonWebToken.encode(id: @user.id) if @user
        render :show, status: :ok
      else
        raise Error::UnauthorizedError.new('Invalid username or password')
      end
    end

    def show
      render :show, status: :ok
    end

    private

    def encrypt_password
      raise Error::UnprocessableEntityError.new("Password can't be blank") if params[:password_digest].nil?
      raise Error::UnprocessableEntityError.new('Password need to have more than 6 characters') if params[:password_digest].size <= 6
      params[:password_digest] = User.encrypt_password(params[:password_digest])
    end

    def user_params
      params.permit(:username, :email, :password_digest, :first_name, :last_name)
    end
  end
end
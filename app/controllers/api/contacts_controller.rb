module Api
  class ContactsController < AuthsController
    before_action :authorize_user
    before_action :find_contact, only: %i[show update destroy]

    def create
      @contact = Contact.create!(contact_params.merge(user: @user))
      render :show, status: :created
    end

    def index
      @contacts = @user.contacts
      render :index, status: :ok
    end

    def show
      render :show, status: :ok
    end

    def update
      @contact.update!(contact_params)
      render :show, status: :ok
    end

    def destroy
      @contact.destroy!
      render json: {}, status: :ok
    end

    private

    def find_contact
      @contact = @user.contacts.find(params[:id])
    end

    def contact_params
      params.permit(:name, :number)
    end
  end
end
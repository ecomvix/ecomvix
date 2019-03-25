class ContactsController < ApplicationController

    include CurrentCart
    before_action :set_cart, only: [:new, :create]

    def new
        @contact = Contact.new
    end

    def create
        @contact = Contact.new(contact_params)
        if @contact.save
            redirect_to root_url, notice: 'Thank You for Your Message'
        else
          render :new
        end
    end

    private

    def contact_params
        params.require(:contact).permit(:name, :email, :message)
    end

end

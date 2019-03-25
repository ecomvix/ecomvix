class Contact < ApplicationRecord
     validates :name, :email, presence: true
    validates :message, presence: true, length: {maximum: 300}
end

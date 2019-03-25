class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


   # validates :first_name, :last_name, presence: true
         validates :email, presence: true, uniqueness: { case_sensitive: false },
             format: { with: /\A[A-Z0-9#_-~!$&'()*+,;=:.%]+@[A-Z0-9.-]+\.[A-Z]{2,4}\z/i}

  def full_name
    "#{first_name} #{last_name}"
  end
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :confirmable, :trackable,
         :recoverable, :rememberable, :validatable

  enum role: [:basic, :admin]
end

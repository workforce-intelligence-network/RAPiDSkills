class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :trackable,
         :recoverable, :rememberable, :validatable

  enum role: [:basic, :admin]

  belongs_to :employer, class_name: 'Organization', optional: true
  has_many :data_imports

  delegate :title, to: :employer, prefix: true, allow_nil: true
end

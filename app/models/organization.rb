class Organization < ApplicationRecord
  validates :title, presence: true, uniqueness: true

  has_many :locations
  has_one_attached :logo
end
      
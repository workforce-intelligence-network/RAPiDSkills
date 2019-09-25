class State < ApplicationRecord
  validates :short_name, presence: true, uniqueness: true
  validates :long_name, presence: true, uniqueness: true

  has_many :locations
  has_many :organizations, through: :locations
  has_many :standard_registrations

  def to_s
    long_name
  end
end

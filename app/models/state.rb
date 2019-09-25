class State < ApplicationRecord
  validates :short_name, presence: true, uniqueness: true
  validates :long_name, presence: true, uniqueness: true
end

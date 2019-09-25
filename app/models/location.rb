class Location < ApplicationRecord
  belongs_to :organization
  belongs_to :state

  def to_s
    city
  end
end

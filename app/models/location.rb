class Location < ApplicationRecord
  belongs_to :organization
  belongs_to :state
end

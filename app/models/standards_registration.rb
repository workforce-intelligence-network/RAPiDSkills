class StandardsRegistration < ApplicationRecord
  belongs_to :occupation_standard
  belongs_to :organization
  belongs_to :state
end

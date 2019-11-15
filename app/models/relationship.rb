class Relationship < ApplicationRecord
  belongs_to :user
  belongs_to :occupation_standard
end

class Relationship < ApplicationRecord
  belongs_to :user
  belongs_to :occupation_standard

  validates :occupation_standard, uniqueness: { scope: :user }
end

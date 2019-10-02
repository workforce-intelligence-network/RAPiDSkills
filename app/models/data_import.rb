class DataImport < ApplicationRecord
  has_one_attached :file

  enum kind: [:occupation_standards]
end

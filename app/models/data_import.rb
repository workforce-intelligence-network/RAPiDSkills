class DataImport < ApplicationRecord
  include Redis::Objects

  validates :file, :kind, presence: true

  belongs_to :creator, polymorphic: true
  has_one_attached :file

  enum kind: [:occupation_standards]

  value :blob_key

  before_save :run_import, if: :file_changed?
  after_save :set_blob_key

  private

  def file_changed?
    new_record? || blob_key.value != file.blob.key
  end

  def run_import
    # Import data here according to kind
  end

  def set_blob_key
    self.blob_key = file.blob.key
  end
end

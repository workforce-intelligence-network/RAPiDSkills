class DataImport < ApplicationRecord
  include Redis::Objects

  has_one_attached :file

  enum kind: [:occupation_standards]

  value :blob_key

  after_save :run_import, if: :file_changed?

  private

  def file_changed?
    blob_key.value != file.blob.key
  end

  def run_import
    # Import data here according to kind
    self.blob_key = file.blob.key
  end
end

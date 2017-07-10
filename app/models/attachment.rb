class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true, touch: true, optional: true

  mount_uploader :file, FileUploader

  def with_meta
    Hash["filename", file.identifier, "url", file.url]
  end
end

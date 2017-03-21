class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, dependent: :destroy  
  belongs_to :user

  validates :title, :body, length: { minimum: 10, maximum: 255 }
end

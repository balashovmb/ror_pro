class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy 
  belongs_to :user

  validates :title, :body, length: { minimum: 10, maximum: 255 }

  accepts_nested_attributes_for :attachments  
end

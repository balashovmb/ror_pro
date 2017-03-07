class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  
  validates :title, :body, length: { minimum: 10, maximum: 255 }
end

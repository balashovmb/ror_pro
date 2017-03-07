class Question < ApplicationRecord
  has_many :answers
  
  validates :title, :body, length: { minimum: 10 }
end

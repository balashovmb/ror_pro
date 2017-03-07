class Question < ApplicationRecord
  validates :title, :body, length: { minimum: 10 }
end

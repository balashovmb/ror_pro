class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, length: { minimum: 10 }

  def set_best
    self.best = true
    self.save
  end
end

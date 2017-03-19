class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, length: { minimum: 10 }

  def set_best
    transaction do
      Answer.where(question_id: self.question.id, best: true).update_all(best: false)    
      update(best:true)
    end
  end
end

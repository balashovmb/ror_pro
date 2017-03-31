class Answer < ApplicationRecord
  include Attachable
  include Votable

  belongs_to :question
  belongs_to :user


  validates :body, length: { minimum: 10 }


  default_scope { order('best DESC') }

  def set_best
    transaction do
      Answer.where(question_id: question.id, best: true).update_all(best: false)
      update!(best: true)
    end
  end
end

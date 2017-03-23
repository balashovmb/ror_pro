class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy   

  validates :body, length: { minimum: 10 }

  accepts_nested_attributes_for :attachments  

  default_scope { order('best DESC') }

  def set_best
    transaction do
      Answer.where(question_id: question.id, best: true).update_all(best: false)
      update!(best: true)
    end
  end
end

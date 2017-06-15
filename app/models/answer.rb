class Answer < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :user

  validates :body, length: { minimum: 5 }

  after_create_commit { AnswersNotificationJob.perform_later self }

  default_scope { order('best DESC, created_at ASC') }

  def set_best
    transaction do
      Answer.where(question_id: question.id, best: true).update_all(best: false)
      update!(best: true)
    end
  end
end

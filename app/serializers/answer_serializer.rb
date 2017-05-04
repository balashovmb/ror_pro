class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :created_at, :updated_at
  has_many :attachments
  has_many :comments

  def question_id
    object.question_id
  end
end

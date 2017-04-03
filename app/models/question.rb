class Question < ApplicationRecord
  include Attachable
  include Votable

  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, length: { minimum: 10, maximum: 255 }
end

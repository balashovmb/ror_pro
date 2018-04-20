class Question < ApplicationRecord
  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  belongs_to :user

  validates :title, :body, length: { minimum: 5, maximum: 255 }

  after_create :subscribe_author

  scope :ordered_by_time, -> { order(created_at: :desc) }

  private

  def subscribe_author
    subscriptions.create(user_id: user.id)
  end
end

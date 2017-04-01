require 'active_support/concern'

module Votable

  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    votes.create(user: user, value: 1)
  end

  def vote_down(user)
    votes.create(user: user, value: -1)
  end

  def rating
    votes.sum(:value)
  end

  def cancel_vote(user)
    votes.where(user: user).destroy_all
  end

  def exist_vote?(user)
    Vote.where(user: user, votable: self).exists?
  end
   
end
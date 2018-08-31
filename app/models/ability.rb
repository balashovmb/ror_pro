class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :vote_up, :vote_down, :cancel_vote, to: :vote
    alias_action :subscribe_digest, :unsubscribe_digest, to: :digest_subscription

    @user = user

    @user ? user_abilities : guest_abilities
  end

  private

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    api_abilities
    can :create, [Question, Answer, Comment, Attachment, Subscription]
    can [:update, :destroy], [Question, Answer, Comment, Subscription], user_id: @user.id
    can :destroy, Attachment, attachable: { user_id: @user.id }
    can :set_best, Answer, question: { user_id: @user.id }
    can :vote, [Question, Answer] do |votable| 
      !@user.author?(votable) 
    end
    can :digest_subscription, User, id: @user.id
  end

  def api_abilities
    can [:me, :list], User
  end
end

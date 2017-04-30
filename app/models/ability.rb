class Ability
  include CanCan::Ability

  def initialize(user)

    alias_action :vote_up, :vote_down, :cancel_vote, to: :vote

    @user = user
    if @user
      user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities 
    can :create, [Question, Answer, Comment, Attachment]
    can [:update, :destroy], [Question, Answer, Comment], user_id: @user.id
    can :destroy, Attachment, attachable: { user_id: @user.id }
    can :set_best, Answer, question: { user_id: @user.id}
    can :vote, [Question, Answer] { |votable| !@user.author?(votable) }
  end
end

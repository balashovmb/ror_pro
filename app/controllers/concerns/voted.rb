module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up, :vote_down, :cancel_vote]
    before_action :check_users_vote, only: [:vote_up, :vote_down]
    before_action :check_votable_author, only: [:vote_up, :vote_down, :cancel_vote]
  end

  def vote_up
    @votable.vote_up(current_user)
    json_vote_ok
  end

  def vote_down
    @votable.vote_down(current_user)
    json_vote_ok
  end

  def cancel_vote
    @votable.cancel_vote(current_user)
    json_vote_ok
  end

  private

  def json_vote_ok
    render json: { id: @votable.id, rating: @votable.rating, dom_id: "#{@votable.class.name.underscore}_#{@votable.id}" }, status: :ok
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  def check_users_vote
    if @votable.exist_vote?(current_user)
      render json: { id: @votable.id, data: 'You can vote only once' }, status: :unprocessable_entity
    end
  end

  def check_votable_author
    if current_user.author?(@votable)
      render json: { id: @votable.id, data: "You can't vote for your #{model_klass}" }, status: :unprocessable_entity
    end
  end
end

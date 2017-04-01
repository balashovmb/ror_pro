module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: [:vote_up]
    before_action :check_users_vote, only: [:vote_up]
  end

  def vote_up
    @votable.vote_up(current_user)
    render json: { id: @votable.id, status: 'success', rating: @votable.rating }, status: :ok    
  end

  private 

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end

  private

  def check_users_vote
    if @votable.exist_vote?(current_user)
      render json: { id: @votable.id, status: 'error', data: 'You can vote only once',rating: @votable.rating }, status: :ok
    end
  end
end
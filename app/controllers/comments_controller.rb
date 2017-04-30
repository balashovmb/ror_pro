class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: [:new, :create]
  before_action :set_comment, only: :destroy

  after_action :publish_comment, only: :create

  respond_to :js

  authorize_resource

  def new
    @comment = @commentable.comments.build
    respond_with @comment
  end

  def create
    @comment = @commentable.comments.create(comment_params.merge(user_id: current_user.id))
    respond_with @comment
  end

  def destroy
    respond_with @comment.destroy
  end

  private

  def question_id
    if @comment.commentable_type == 'Question'
      @commentable.id
    elsif @comment.commentable_type == 'Answer'
      @commentable.question.id
    end
  end

  def set_commentable
    @commentable = commentable_klass.find(params["#{commentable_name}_id"])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :commentable)
  end

  def commentable_name
    params[:commentable]
  end

  def commentable_klass
    commentable_name.classify.constantize
  end

  def publish_comment
    return if @comment.errors.any?
    data = {
      type: :comment,
      comment: @comment
    }
    ActionCable.server.broadcast("question_comments_#{question_id}", data)
  end
end

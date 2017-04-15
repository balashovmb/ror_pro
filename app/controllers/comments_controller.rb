class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable,      only: :create
  before_action :set_comment,         only: :destroy

  after_action :publish_comment, only: [:create]     
  
  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save       
  end

  def destroy
    if current_user.author?(@comment)
      @comment.destroy
    end
  end

  private

  def question_id
    if @comment.commentable_type == 'Question'
      @commentable.id
    elsif @comment.commentable_type  == 'Answer'
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

    data = {
      type: :comment,
      comment: @comment
    }
    ActionCable.server.broadcast("question_comments_#{question_id}", data)
  end  
end

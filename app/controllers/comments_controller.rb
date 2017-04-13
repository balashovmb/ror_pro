class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentabe,      only: :create
  before_action :set_comment,         only: :destroy  
  
  def create
    @comment = commentable.comments.new(comment_params)
    @comment.user = current_user
    @answer.save       
  end

  def destroy
    if current_user.author?(@comment)
      @comment.destroy
    end
  end

  private

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

end

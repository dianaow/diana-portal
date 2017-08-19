class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article
  before_action :set_comment, only: [:destroy, :edit, :update]
  
  def create
    @comment = @article.comments.new(comment_params)
    @comment.user = current_user
      if @comment.save
        Notification.create!(recipient: @article.user, actor: current_user, action: "posted", notifiable: @comment)
        redirect_to @article
      else
        redirect_to @article
      end
  end
  
  def destroy
    @comment.destroy
    redirect_to @article
  end
  
  def edit
  end

  def update
      if @comment.update(params[:comment].permit(:content))
        redirect_to @article
      else
        render action: :edit
      end
  end

  private

    def set_article
      @article = Article.find(params[:article_id])
    end
    
    def set_comment
      @comment = @article.comments.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
end

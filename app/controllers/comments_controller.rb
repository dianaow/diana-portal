class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article
  before_action :set_comment, only: [:destroy, :edit, :update]
  
  def create
    @comment = @article.comments.new(comment_params)
    @comment.user = current_user
      if @comment.save
        flash[:success] = "Your comment was created successfully"
        unless @comment.article.user == current_user
          Notification.create!(recipient: @article.user, actor: current_user, action: "posted", notifiable: @comment)
        end
        redirect_to @article
      else
        flash[:error] = "Unable to submit comment."
        redirect_to @article
      end
  end
  
  def destroy
    @comment.destroy
    flash[:success] = "Successfully deleted comment"
    redirect_to @article
  end
  
  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
      if @comment.update(params[:comment].permit(:content))
        flash[:success] = "Successfully updated comment"
        redirect_to @article
      else
        render action: :edit
      end
  end

  private

    def set_article
      @article = Article.friendly.find(params[:article_id])
    end
    
    def set_comment
      @comment = @article.comments.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:content)
    end

end

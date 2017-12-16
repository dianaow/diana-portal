class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_article
  before_action :set_comment, only: [:destroy, :edit, :update]

  def create
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user
      if @comment.save
        respond_to do |format|
          format.html { redirect_to @comment.article, :flash => { :success => "Your comment was created successfully" } }
          format.js
        end
        unless @comment.article.user == current_user
          Notification.create!(recipient: @article.user, actor: current_user, action: "posted", notifiable: @comment) 
        end
      else
       respond_to do |format|
          format.html { redirect_to @comment.article, :flash => { :error => "Unable to submit comment."} }
          format.js
        end
      end
  end
  
  def destroy
    @article = @comment.article
    if @comment.destroy
      respond_to do |format|
        format.html { redirect_to @comment.article, :flash => { :success =>  "Successfully deleted comment" } }
        format.js  
      end
    else
     respond_to do |format|
        format.html { redirect_to @comment.article, :flash => { :error => "Unable to delete comment."} }
        format.js
      end
    end
  end
  
  def edit
    respond_to do |format|
      format.html { redirect_to @comment.article}
      format.js
    end
  end

  def update
    if @comment.update(params[:comment].permit(:content))
      respond_to do |format|
        format.html { redirect_to @comment.article, :flash => { :success =>  "Successfully edited comment" } }
        format.js
      end
    else
     respond_to do |format|
        format.html { redirect_to @comment.article, :flash => { :error =>  "Unable to edit comment."} }
        format.js
      end
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

class ArticlesController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :set_article, only: [:show, :edit, :update, :destroy, :toggle_vote]
    impressionist :actions=>[:show]

  def index
    @articles = Article.order("updated_at DESC").all
    @articles_views = Article.order("impressions_count ASC").all
    @articles_votes = Article.order("cached_votes_up DESC").all
  end

  def show
    @article = Article.find(params[:id])
    @comments = Comment.where(article_id: @article).order("created_at DESC")
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.new(article_params)
    if @article.save
      redirect_to @article
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to @article
    else
      render action: :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path
  end
  
  def toggle_vote
    @user = current_user
    if @user.voted_up_on? @article
      @article.unvote_by current_user
      redirect_to @article
    else
      @article.upvote_by current_user
      redirect_to @article
    end
  end

  private

    def set_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :description, :user_id)
    end
end

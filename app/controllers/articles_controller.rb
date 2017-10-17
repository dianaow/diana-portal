class ArticlesController < ApplicationController
    
    before_action :authenticate_user!
    before_action :set_article, only: [:show, :edit, :update, :destroy, :toggle_vote]
    before_action :set_articles, only: [:browse, :sort]
    include ArticlesHelper
    before_action only: [:sort] do
      get_query('query_articles')
    end

  def index
    @articles = Article.published.order("updated_at DESC")
    @articles_views = Article.published.order("impressions_count DESC")
    @articles_votes = Article.published.order("cached_votes_up DESC")
  end

  def show
    if @article.status == "draft" && @article.user != current_user
      redirect_to root_path
    else
      @article_categories = @article.categories
      @comments = @article.comments.order("created_at DESC")
      impressionist(@article)
    end
  end

  def new
    @article = Article.new
  end

  def create
    @article = current_user.articles.new(article_params)
    if @article.save
      redirect_to @article, notice: 'Your article was created successfully'
    else
      render action: :new
    end
  end

  def edit
    if @article.user != current_user then redirect_to root_path end
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: 'Your article was edited successfully'
    else
      render action: :edit
    end
  end

  def destroy
    @article.delete
    redirect_to articles_path, notice: 'Your article was deleted successfully'
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
  
  def drafts
    @articles = current_user.articles.draft.paginate(page: params[:page], per_page: 10).order("updated_at DESC")
  end
  
  def browse
    @categories = Category.with_articles.order('name ASC').all
  end
  
  def sort
    if params[:type] == 'title_asc'
      @articles = @articles.order_by_title_asc
    elsif params[:type] == 'title_desc'
      @articles = @articles.order_by_title_desc
    elsif params[:type] == 'created_at_desc'
      @articles = @articles.order_by_created_at_desc
    elsif params[:type] == 'impressions_count_desc'
      @articles = @articles.order_by_impressions_count_desc
    elsif params[:type] == 'cached_votes_up_desc'
      @articles = @articles.order_by_cached_votes_up_desc
    end
      
    respond_to do |format|
      format.js
    end
  end
  
  private

    def set_article
      @article = Article.friendly.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :description, :user_id, :status, category_ids: [])
    end
    
    def set_articles
      @q = Article.ransack(params[:q])
      @articles = @q.result.includes(:categories, :users)
    end
    
end

class ArticlesController < ApplicationController
  before_action :authenticate_user!, except:[:index, :show]
  before_action :set_article, only: [:show, :edit, :update, :destroy, :upvote, :downvote]
  include ArticlesHelper
  
  def index
    @q = Article.published.ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @articles = @q.result(distinct: true).includes(:categories, :users).paginate(page: params[:page], per_page: 15)
    @categories = Category.with_articles.order('name ASC').all

    if params[:s] != nil
      if params[:q][:s] == 'title asc'
        @articles = @articles.order_by_title_asc
      elsif params[:q][:s] == 'title desc'
        @articles = @articles.order_by_title_desc
      elsif params[:q][:s] == 'created_at desc'
        @articles = @articles.order_by_created_at_desc
      elsif params[:q][:s] == 'impressions_count desc'
        @articles = @articles.order_by_impressions_count_desc
      elsif params[:q][:s] == 'cached_votes_up desc'
        @articles = @articles.order_by_cached_votes_up_desc
      end
    end
  end
  
  def show
    if @article.status == "draft" && @article.user != current_user
      redirect_to root_path
    else
      @article_categories = @article.categories
      @comments = @article.comments
      @new_comment = @article.comments.new
      impressionist(@article)
    end
  end
  
  def new
    @article = Article.new(:status => "published")
  end

  def create
    @article = current_user.articles.new(article_params)
    if @article.save
      flash[:success] = 'Your article was created successfully'
      redirect_to @article
    else
      render action: :new
    end
  end

  def edit
    if @article.user != current_user then 
      redirect_to root_path 
      flash[:error] = 'You are not authorized to edit this article'
    end
  end

  def update
    if @article.update(article_params)
      flash[:success] = 'Your article was edited successfully'
      redirect_to @article
    else
      render action: :edit
    end
  end

  def destroy
    @article.destroy
    flash[:success] = 'Your article was deleted successfully'
    redirect_to articles_path
  end
  
  def upvote
    @article.upvote_by current_user
    respond_to do |format|
      format.html { redirect_to @article }
      format.js
      end
  end
   
  def downvote
    @article.downvote_by current_user
    respond_to do |format|
      format.html { redirect_to @article }
      format.js
      end
  end
  
  def drafts
    @articles = current_user.articles.draft.paginate(page: params[:page], per_page: 10).order("updated_at DESC")
  end

  private

    def set_article
      @article = Article.friendly.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :summary, :description, :user_id, :status, category_ids: [])
    end

end

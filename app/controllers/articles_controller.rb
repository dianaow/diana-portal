class ArticlesController < ApplicationController
    
    before_action :authenticate_user!
    before_action :set_article, only: [:show, :edit, :update, :destroy, :toggle_vote]
    
  def index
    @q = Article.published.ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @articles = @q.result(distinct: true).includes(:categories, :users).paginate(page: params[:page], per_page: 20)
    @categories = Category.with_articles.order('name ASC').all

    if params[:s] != nil
      if params[:q][:s] == 'title asc'
        @articles = @articles.order_by_title_asc
      elsif params[:q][:s] == 'title desc'
        @articles = @articles.order_by_title_desc
      elsif params[:q][:s] == 'created_at desc'
        @articles = @articles.order_by_created_at_desc
      elsif params[:q][:s] == 'impressions_count asc'
        @articles = @articles.order_by_impressions_count_asc
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
      @comments = @article.comments.order("created_at DESC")
      impressionist(@article)
    end
    respond_to do |format|
      format.html
      format.js {render layout: false}
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
    if @article.user != current_user then redirect_to root_path end
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

  private

    def set_article
      @article = Article.friendly.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :description, :user_id, :status, category_ids: [])
    end

end

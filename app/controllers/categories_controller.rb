class CategoriesController < ApplicationController
before_action :authenticate_user!

  def index
    @categories = Category.with_articles.order('name ASC').limit(2)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @category = Category.find(params[:id])
    @articles = @category.articles
  end

end
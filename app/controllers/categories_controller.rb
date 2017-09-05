class CategoriesController < ApplicationController
before_action :authenticate_user!

  def index
    @categories = Category.with_articles
  end

  def show
    @category = Category.find(params[:id])
    @articles = @category.articles
  end

end
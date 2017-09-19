class CategoriesController < ApplicationController
before_action :authenticate_user!

  def index
    if params[:id]
      @categories = Category.order('created_at DESC').where('id < ?', params[:id]).limit(2)
    else
      @categories = Category.order('created_at DESC').limit(2)
    end
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
class CategoriesController < ApplicationController
before_action :authenticate_user!
impressionist :actions=>[:show]

  def index
    if params[:id]
      @categories = Category.order('created_at DESC').where('id < ?', params[:id]).limit(3)
    else
      @categories = Category.order('created_at DESC').limit(3)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @category = Category.find(params[:id])
    @articles = @category.articles.order("impressions_count DESC").paginate(page: params[:page], per_page: 15)
    impressionist(@category)
  end

end
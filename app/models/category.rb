class Category < ApplicationRecord
has_many :article_categories
has_many :articles, through: :article_categories
validates :name, presence: true
validates_uniqueness_of :name

  def self.with_articles
    includes(:articles).where.not(articles: { id: nil, status: "draft" })
  end
  
  def self.popular
    Category.articles.order("impressions_count ASC").limit(9)
  end
  
  
end
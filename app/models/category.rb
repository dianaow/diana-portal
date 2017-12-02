class Category < ApplicationRecord
has_many :article_categories
has_many :articles, through: :article_categories
validates :name, presence: true
validates_uniqueness_of :name
is_impressionable :counter_cache => true, :unique => false

  def self.with_articles
    includes(:articles).where.not(articles: { id: nil, status: "draft" })
  end

  def self.order_by_impressions(current_user)
    self.joins(:articles)
        .joins(:impressions)
        .where(impressions: { user_id: current_user} )
        .group("categories.id")
        .order('categories.impressions_count DESC')
  end
  
  def self.top_3_visited(current_user)
    order_by_impressions(current_user).limit(3)
  end

end

class Category < ApplicationRecord
has_many :article_categories
has_many :articles, through: :article_categories
validates :name, presence: true
validates_uniqueness_of :name
is_impressionable :counter_cache => true, :unique => true

  def self.with_articles
    includes(:articles).where.not(articles: { id: nil, status: "draft" })
  end

  
  def self.order_by_impressions(current_user)
    self.joins(:articles)
        .joins(:impressions)
        .where("impressions.ip_address ='#{current_user.current_sign_in_ip}'")
        .group("impressions.impressionable_id")
        .group("categories.id")
        .order('SUM(articles.impressions_count + categories.impressions_count) DESC')
  end
  
  def self.top_3_visited(current_user)
    order_by_impressions(current_user).limit(3)
  end



  
  def self.sorted_by_popular
    User.all.sort_by(&:popular).reverse
  end
  
end
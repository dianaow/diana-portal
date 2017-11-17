class Article < ApplicationRecord
  enum status: { draft: 1, published: 0 }
  extend FriendlyId
  friendly_id :title, use: :slugged
  is_impressionable :counter_cache => true, :unique => false
  acts_as_votable
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :users, through: :comments
  has_many :impressions, as: :impressionable
  has_many :article_categories
  has_many :categories, through: :article_categories

  validates :title, presence: true, length: { minimum: 10, maximum: 100 }
  validates :summary, presence: true, length: { minimum: 10, maximum: 180 }
  validates :description, presence: true, length: { minimum: 10 }
  
  def age_group
    months_between = Date.today.month - self.created_at.month
    if months_between > 12
        age = "more than 1 year ago"
    elsif months_between  <= 12
        age = "less than 1 year ago"
    elsif months_between  <= 3
        age = "less than 3 months ago"
    elsif months_between <= 1
        age = "less than 1 month ago"
    end
  end
  
  scope :order_by_title_asc, -> { order(title: :asc) }
  scope :order_by_title_desc, -> { order(title: :desc) }
  scope :order_by_created_at_desc, -> { order(created_at: :desc) }
  scope :order_by_impressions_count_desc, -> { order(impressions_count: :desc) }
  scope :order_by_cached_votes_up_desc, -> { order(cached_votes_up: :desc) }

              
  def self.order_by
	[
	    ['Sort By', ''],
		['Newest', 'created_at desc'],
		['Title: A to Z', 'title asc'],
		['Title: Z to A', 'title desc'],
		['Highest View Count', 'impressions_count desc'],
		['Highest Rated', 'cached_votes_up desc'],
	]
  end
  
  def popular_score
    return ((self.impressions_count * 0.6) + (self.cached_votes_up * 0.4))
  end
  
  def self.sorted_by_popular_score
    Article.all.sort_by(&:popular_score).reverse
  end

  def self.unique_impression_count
     Article.impressionist_count(:filter=>:ip_address)
  end
  

end

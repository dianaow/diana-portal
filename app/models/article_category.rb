class ArticleCategory < ActiveRecord::Base

belongs_to :article
belongs_to :category

  def popular
    order("impressions_count ASC").limit(9)
  end

end
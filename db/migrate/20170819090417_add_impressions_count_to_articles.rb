class AddImpressionsCountToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :impressions_count, :integer
  end
end
